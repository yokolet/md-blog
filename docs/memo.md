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
