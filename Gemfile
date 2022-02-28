source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# MongoDB is our main database
gem 'mongoid'
# Speed up BSON serialization
gem 'bson_ext'

# Soft delete
gem 'mongoid_paranoia'

# Mongoid enums
gem 'mongoid-enum', git: 'https://github.com/StudentKickOff/mongoid-enum'

# Bulma is CSS bae
gem 'bulma-rails'

# Slim templating <3
gem 'slim-rails'

# i18n
gem 'rails-i18n', '~> 5.0.0'

# JQuery
gem "jquery-rails"

# fancy selection
gem "select2-rails"

# Dynamic forms
gem 'cocoon'

# Font Awesom
gem 'font-awesome-rails'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'

  gem 'rspec'

  gem 'mimemagic'

  # Time sensitive tests
  gem 'timecop'

  # Fake stuff
  gem 'faker'

  # Deployment
  gem "capistrano", "~> 3.9"
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-passenger'
  gem "capistrano-rails"
  gem "ed25519", "~> 1.2"
  gem "bcrypt_pbkdf", "~> 1.1"
  gem "rbnacl", "<5.0.0"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Livereload
  gem 'guard'
  gem 'guard-livereload', '~> 2.5', require: false

  # rails_panel
  gem 'meta_request'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
