### GraphQL Setup and Development

#### Install GraphQL

Don't do `bundle add graphql` since it tries to install GraphiQL (GraphQL client).
Some of GraphQL clients are out there and provide much better experiences.

Edit Gemfile and add graphql gem.

```ruby
gem "graphql"
```
```bash
% bundle add graphql
% rails g graphql:install
```

Unfortunately, GraphQL installer tries to install GraphiQL UI, which won't be used here.
Additionally, the installation has a flaw, which prevents to start the server.

Delete GraphiQL.
Edit Gemfile and remove the line, `gem "graphiql-rails", group: :development`.
Edit config/routes.rb delete the code block below:
```ruby
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
```
Then, run
```bash
% bundle install
```

Above might add GraphiQL to the Gemfile again.
If so, remove again and run bundle install.

#### Add CSRF in Controller

This Rails app is not API only server, it needs CSRF setting.

Add blow to app/controllers/graphql_controller.rb.
```ruby
protect_from_forgery with: :null_session
```

#### Create GraphQL Types
```bash
% rails g graphql:object user
% rails g graphql:object post
% rails g graphql:object comment
```

The graphql generator sees model definitions and generates types to meet each model.

#### Define Query Resolvers
```bash
% mkdir -p app/graphql/resolvers
```

- User Query
  - Full user info should be allowed for a user-self with authentication
  - Added public profile for posts/comments user
- Post Query
  - For a list of posts, the PostListType was added
  - For a single post, post owner's username was added to the type
- Comment Query
  - Only returns a list of comments given post id

#### Query Examples
- Public Profile
  ```graphql
  query publicProfile {
    publicProfile(id: 6) {
      id
      username
    }
  }
  ```
- Post List
  ```graphql
  query postList {
    postList {
      id
      title
      commentCount
      username
    }
  }
  ```
- Single Post
  ```graphql
  query post($pid: Int!) {
    post(id: $pid) {
      id
      title
      content
      username
    },
    commentList(postId: $pid) {
      postId
      body
      username
    }
  }
  
  {"pid": 12}
  ```
- Me query -- signed-in user's info
  ```graphql
  query {
    me {
      id
      provider
      uid
      username
      email
      accessToken
      expiry
    }
  }
  ```

#### Define Mutations
[Note] User signup/login are done by OAuth 2 PKCE.
From the mechanism of OAuth 2 PKCE, this part is implemented in REST API.

Mutations:
- signed-in user can create a post
- signed-in user can write a comment on someone else's (including own) post

Below commands creates a mutation template.
```bash
% rails g graphql:mutation_create post
% rails g graphql:mutation_create comment
```


#### Mutation Examples
- Post mutation -- signed-in user can create a post - user_id is provided from context
  ```graphql
  mutation post($title: String!, $content: String!) {
    postCreate(input: {
      title: $title,
      content: $content
    }) {
      post {
        id
        title
        content
        userId
        createdAt
        updatedAt
        username
      }
    }
  }
  ```

- Comment mutation -- signed-in user can create a post - user_id is provided from context
  ```graphql
  mutation comment($pid: ID!, $body: String!) {
    commentCreate(input: {
      postId: $pid,
      body: $body
    }) {
      comment {
        id
        body
        userId
        postId
        createdAt
        updatedAt
        username
      }
    }
  }
  ```

#### Request Specs

For an authenticated user, the Authorization header should present.
The value is an encoded JWT token.
Add jwt_secret to Rails' credentials file.
```bash
% EDITOR=vim rails credentials:edit
```

```
jwt_secret: YOUR-JWT-SECRET-HERE
```

To generate a random JWT secret, below works.
```bash
% node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Add JWT gem.
```bash
% bundle add jwt
```



### References
- [Screencast: Testing GraphQL with Rails and RSpec](https://dev.to/phawk/screencast-testing-graphql-with-rails-and-rspec-303m)
- [GraphQL error handling with graphql-ruby](https://medium.com/@takewakamma/graphql-error-handling-with-graphql-ruby-653aa2a129f6)
- [Testing GraphQL-Ruby Mutations With RSpec](https://dev.to/rjrobinson/testing-graphql-ruby-mutations-with-rspec-3ngc)
- [GraphQL Ruby Integration Tests](https://graphql-ruby.org/testing/integration_tests)
- [Testing GraphQL Mutations In Ruby On Rails With RSpec](https://selleo.com/blog/testing-graphql-mutations-in-ruby-on-rails-with-rspec)
- [How I Test GraphQL in Rails With RSpec](https://jamesnewton.com/blog/how-i-test-graphql-in-rails-with-rspec)
- [Getting Started with Hanami and GraphQL](https://lucaguidi.com/2023/02/06/getting-started-with-hanami-and-graphql/)
