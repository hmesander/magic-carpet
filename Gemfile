source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'omniauth-lyft'
gem 'figaro'
gem 'faraday'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'simplecov'
  gem 'faker'
  gem "factory_bot_rails", "~> 4.0"
end

group :test do
  gem 'webmock'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Added at 2018-07-16 15:05:31 -0600 by zacharythomas:
gem "rspec-rails", "~> 3.7"

# Added at 2018-07-16 15:05:39 -0600 by zacharythomas:
gem "pry", "~> 0.11.3"

# Added at 2018-07-16 15:05:50 -0600 by zacharythomas:
gem "selenium", "~> 0.2.11"

# Added at 2018-07-16 15:05:57 -0600 by zacharythomas:
gem "capybara", "~> 3.3"

# Added at 2018-07-19 16:33:22 -0600 by zacharythomas:
gem "jwt", "~> 1.5"

# Added at 2018-07-27 11:04:54 -0600 by zacharythomas:
gem "active_model_serializers", "~> 0.10.7"
