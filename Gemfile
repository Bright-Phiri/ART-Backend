# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem 'active_storage_validations'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cloudinary'
gem 'fast_jsonapi'
gem 'net-http'
gem 'rails', '~> 7.0.0'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use Redis adapter to run Action Cable in production
gem 'ffi'
gem 'image_processing', '~> 1.2'
gem 'jwt'
gem 'pg'
gem 'redis', '~> 4.0'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'sidekiq'
# gem 'rubocop', '~> 1.39', require: false
gem 'twilio-ruby'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :production do
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
