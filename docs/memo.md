### How this app is developed

#### Creates a Rails app

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

#### Adds Testing Gems

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
