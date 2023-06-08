### How this app is developed

#### Create a Rails app

- command
```bash
% rails new md-blog --rc=./.railsrc-blog
```
- .railsrc-blog
```bash
--skip-action-mailer
--skip-action-mailbox
--skip-action-cable
--skip-action-text
--skip-active-job
--skip-active-storage
-d postgresql
-j esbuild
-c tailwind
-T
```

Since the database is PostgreSQL, run below to create databases.
```bash
% rails db:create
```

#### Add Testing Gems

Gems for testing were added:

```ruby
# Gemfile

group :test do
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "factory_bot_rails"
  gem "database_cleaner-active_record"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "faker"
end
```

- command

```bash
% bundle install
% rails g rspec:install
```

#### Setup Database Cleaner

Open spec/rails_helper.rb and set false to config.use_transactional_fixtures
since that is taken care of by the database cleaner.

```ruby
# spec/rails_helper.rb

...
RSpec.configure do |config|
  ...
  config.use_transactional_fixtures = false
  ...
end
```

Create a file, spec/support/database_cleaner.rb, for database cleaner setup.
```ruby
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```

Add a require statement in spec/rails_helper.rb.
```ruby
...
require 'support/database_cleaner'
...
```

- References
  - [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner/blob/main/README.markdown)
  - [How To Set Up Rails With RSpec, Capybara, and Database_cleaner](https://betterprogramming.pub/how-to-set-up-rails-with-rspec-capybara-and-database-cleaner-aacb000070ef)
  - [Setting up RSpec and DatabaseCleaner to support multiple databases](https://medium.com/productboard-engineering/setting-up-rspec-and-databasecleaner-to-support-multiple-databases-c42bfe251112)


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

- References
  - [The Rails Command Line](https://guides.rubyonrails.org/command_line.html)
  - [Active Record Migrations](https://guides.rubyonrails.org/active_record_migrations.html)
  - [Rails Generator Cheatsheet](https://dev.to/alicannklc/rails-generator-cheatsheet-1dfn)
  - [Don't forget: Automatically remove join records on has_many :through associations](https://makandracards.com/makandra/32175-don-t-forget-automatically-remove-join-records-on-has_many-through-associations)
