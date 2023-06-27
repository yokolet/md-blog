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

#### Create a Controller to Redirect Back to the Client app
```bash
% rails g controller pages home
```
Edit config/routes.rb.
```ruby
Rails.application.routes.draw do
  root 'pages#home'
  #...
  #...
end
```

#### Request Spec's External Access Mocking

During the OAuth2 PKCE authentication process, the controller makes two HTTP requests to the auth endpoint.
Those HTTP requests are mocked using WebMock gem.

The payload for the stubbed request is tricky.
As in blow, code and code_verifier should be nil.
The client_id is required to be a real one.
```ruby
let!(:token_payload) do
  {
    "redirect_uri"=>"http://www.localhost:3000/oauth/twitter",
    "code"=>nil,
    "grant_type"=>"authorization_code",
    "client_id"=>Rails.application.credentials.twitter.client_id,
    "code_verifier"=>nil
  }
end
```


### References
#### Proof Key for Code Exchange
- [RFC 7636: Proof Key for Code Exchange](https://oauth.net/2/pkce/)
- [Authorization Code Flow with Proof Key for Code Exchange (PKCE)](https://blog.miniorange.com/auth-flow-with-pkce/)
- [Authorization Code Flow with PKCE (OAuth) in a React application](https://hceris.com/oauth-authorization-code-flow-pkce-for-react/)
- [Twitter Documentation: Authentication](https://developer.twitter.com/en/docs/authentication/oauth-2-0/authorization-code)
- [Spotify for Developers: Authorization Code with PKCE Flow](https://developer.spotify.com/documentation/web-api/tutorials/code-pkce-flow)

#### Implementation
- [Implementing Authentication with Twitter OAuth 2.0 using Typescript, Express.js and Next.js](https://dev.to/reinforz/implementing-authentication-with-twitter-oauth-20-using-typescript-node-js-express-js-and-next-js-in-a-full-stack-application-353d)
- [Create a React App with TS, Redux and OAuth 2.0 - Spotify login example](https://medium.com/swlh/create-a-react-app-with-typescript-redux-and-oauth-2-0-7f62d57890df)

#### Testing
- [How to Stub External Services in Tests](https://thoughtbot.com/blog/how-to-stub-external-services-in-tests)
- [WebMock](https://github.com/bblimke/webmock)
