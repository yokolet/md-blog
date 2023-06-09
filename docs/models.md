### Models

#### Create Models

##### user, post and comment models
```bash
% rails g model User provider:integer uid:string username:string email:string access_token:string expiry:datetime
% rails g model Post title:string{50} content:text user:references
% rails g model Comment body:string{300} user:references post:references
% rails db:migrate
```

##### set null: false constraints
```bash
% rails g migration AddNullFalseConstraints
```
```ruby
class AddNullFalseConstraints < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:users, :provider, false)
    change_column_null(:users, :uid, false)
    change_column_null(:users, :username, false)
    change_column_null(:users, :access_token, false)
    change_column_null(:users, :expiry, false)
    change_column_null(:posts, :title, false)
    change_column_null(:posts, :content, false)
    change_column_null(:comments, :body, false)
  end
end
```
```bash
% rails db:migrate
```

##### add index to user table
```bash
% rails g migration AddIndexToUsers
```
```ruby
class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index(:users, [:provider, :uid], unique: true, name: 'by_provider_uid')
  end
end
```

```bash
% rails db:migrate
```

##### update models
```ruby
# app/models/user.rb

class User < ApplicationRecord
  enum provider: [:local, :twitter]
  # validation
  validates_presence_of :provider, :uid, :username, :access_token, :expiry
  # Association
  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts

  def self.from_auth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.username = auth.info.username
    end
  end
end
```

```ruby
# app/models/post.rb

class Post < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :content
  validates_length_of :title, minimum: 1, maximum: 50
  validates_length_of :content, minimum: 1, maximum: 5000
  has_many :comments, dependent: :destroy
end
```

```ruby
# app/models/comment.rb

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates_presence_of :body
  validates_length_of :body, minimum: 1
end
```

#### Update Foreign Key Constraint

PostgreSQL complains when a parent model's destroy method gets called.
The error is something like:
"PG::ForeignKeyViolation: ERROR:  update or delete on table "users" violates foreign key constraint..."

The foreign keys should have ON DELETE CASCADE option.
To fix this, create a migration.
```bash
% rails g migration UpdateForeignKeyConstraint
```
```ruby
class UpdateForeignKeyConstraint < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :posts, :users
    add_foreign_key :posts, :users, on_delete: :cascade

    remove_foreign_key :comments, :users
    add_foreign_key :comments, :users, on_delete: :cascade

    remove_foreign_key :comments, :posts
    add_foreign_key :comments, :posts, on_delete: :cascade
  end
end
```
```bash
% rails db:migrate
```


### Create Model Specs

#### generate specs
```bash
% rails g rspec:model user
% rails g rspec:model post
% rails g rspec:model comment
```

At this point, `bundle exec rspec` command should work and report three pending results.
If not, something of settings are not going well. Fix that.

#### define factories
```bash
% rails g factory_bot:model user
% rails g factory_bot:model post
% rails g factory_bot:model comment
```

**IMPORTANT**\
Verify Gemfile. The order matters. The factory_bot_rails gem should come after rspec-rails gem.
Unless, the factory_bot generator creates under test, not spec directory.


#### Run Rspec
```bash
% bundle exec rspec
```

### References
- [The Rails Command Line](https://guides.rubyonrails.org/command_line.html)
- [Active Record Migrations](https://guides.rubyonrails.org/active_record_migrations.html)
- [Rails Generator Cheatsheet](https://dev.to/alicannklc/rails-generator-cheatsheet-1dfn)
- [Don't forget: Automatically remove join records on has_many :through associations](https://makandracards.com/makandra/32175-don-t-forget-automatically-remove-join-records-on-has_many-through-associations)
- [Factory Bot cheatsheet](https://devhints.io/factory_bot)
- [Shoulda Matchers](https://matchers.shoulda.io/)
- [How to Test Rails Models with RSpec](https://semaphoreci.com/community/tutorials/how-to-test-rails-models-with-rspec)
