### OAuth 2 PKCE Implementation -- Backend

#### Prerequisite

- Twitter Social Login Setup
  - Go to [Developer Portal](https://developer.twitter.com/en/portal/dashboard) and create an app
  - The Callback URI / Redirect URL should have "www" in the URL. \
    This app uses "http://www.localhost:3000/oauth/twitter" for the redirect URL.

#### Update Credentials File
Once the social login is setup, client id and client secret can be seen on the dashboard.
Update Rails credentials file.
```bash
% EDITOR=vim rails credentials:edit
```

Format of client id and secret is blow:
```
twitter:
  client_id: YOUR-TWITTER-APP-CLIENT-ID-HERE
  client_secret: YOUR-TWITTER-APP-CLIENT-SECRET-HERE
```

#### Faraday Install

During authentication process, Rails app needs to make an HTTP request to Twitter's auth endpoint.
For that purpose, install faraday gem.

```bash
% bundle add faraday
```

#### Create a model to save state and code_verifier
Both state and code_verifier are strings of random character.
Both state and code_verifier should be passed to a client app such as SPA.
Suppose the SPA is created by ReactJS,
the React app initiates OAuth 2 PKCE authentication.
The React app generates a code_challenge from the code_verifier passed from the Rails app.
When the React app navigates to the OAuth provider's endpoint,
it sends the state and code_challenge along with some more parameters.
After a successful authentication,
the auth endpoint sends back the state with a code to the redirect URL, a.k.a. Rails controller.
Rails' controller finds the code_verifier from database using the returned state.
Then, Rails' controller makes a subsequent request to the auth endpoint using the code_verifier and returned code to get an access token.

Above is a reason to create a model to save the state and code_verifier.
The state should be unique, while the code_verifier is not required to be unique.

The state/code_verifier entry should be destroyed once an access_token is returned from the auth endpoint.

```bash
% rails g model pkce state:string:index code_verifier:string
% rails g migration AddNullFalseConstraintsToPKCE
% rails g migration AddUniqueConstraintsToPKCE
```

```ruby
class AddNullFalseConstraintsToPkce < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:pkces, :state, false)
    change_column_null(:pkces, :code_verifier, false)
  end
end
```

```bash
% rails db:migrate
```

#### Create a Controller to Send Back OAuth2 Config Info
The controller returns config info so that the client app can
create an URL for a social login including params to be sent to auth endpoint.

```bash
% rails g controller oauth2_config twitter --skip-template-engine
```

For a static config info, create config/initializers/oauth2_configs.rb.
```ruby
# config/initializers/oauth2_configs.rb
TWITTER_OAUTH2_CONFIG = {
        redirect_uri: 'http://www.localhost:3000/oauth/twitter',
        authEndpoint: 'https://twitter.com/i/oauth2/authorize'
}.freeze
```


#### Create a Controller for the Redirect URL
```bash
% rails g controller oauth twitter --skip-template-engine
```

#### Request Specs

Install Webmock gem.
```ruby
# Gemfile
group :test do
  gem "webmock"
end
```



### References
- [How to Stub External Services in Tests](https://thoughtbot.com/blog/how-to-stub-external-services-in-tests)
