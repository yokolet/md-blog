### Settings

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
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "faker"
  gem "factory_bot_rails"
end
```

**IMPORTANT**\
The order matters -- factory_bot_rails should come after rspec-rails.
This is for the factor_bot generator to create factory models under spec directory.
Unless, the generator creates under test directory.

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

#### Setup Factory Bot

Create a file, spec/support/factory_bot.rb, for factory_bot setup.
```ruby
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```

Add a require statement in spec/rails_helper.rb.
```ruby
...
require 'support/factory_bot'
...
```

#### Setup Shoulda Matchers

Create a file, spec/support/shoulda-matchers.rb, for shoulda-matchers setup.
```ruby
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

Add a require statement in spec/rails_helper.rb.
```ruby
...
require 'support/shoulda-matchers'
...
```

### References
- [Database Cleaner](https://github.com/DatabaseCleaner/database_cleaner/blob/main/README.markdown)
- [How To Set Up Rails With RSpec, Capybara, and Database_cleaner](https://betterprogramming.pub/how-to-set-up-rails-with-rspec-capybara-and-database-cleaner-aacb000070ef)
- [Setting up RSpec and DatabaseCleaner to support multiple databases](https://medium.com/productboard-engineering/setting-up-rspec-and-databasecleaner-to-support-multiple-databases-c42bfe251112)
- [factory_bot/GETTING_STARTED.md](https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md)
