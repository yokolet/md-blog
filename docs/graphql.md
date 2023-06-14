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
  query postLlist {
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



### References
- [GraphQL error handling with graphql-ruby](https://medium.com/@takewakamma/graphql-error-handling-with-graphql-ruby-653aa2a129f6)
- 
