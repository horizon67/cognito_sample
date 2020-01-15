# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'bootsnap'
gem 'falcon'
gem 'rails'

gem 'webpacker', github: 'rails/webpacker'

# Use mysql as the database for Active Record
gem 'mysql2'

# auth
gem 'devise'
gem 'devise-bootstrap-views'

# HTML template engine
gem 'html2slim'
gem 'slim-rails'

## Use pry
gem 'pry'
gem 'pry-byebug'
gem 'pry-rails'
gem 'pry-stack_explorer'

# Handle environment variables
gem 'dotenv-rails'

gem 'omniauth-cognito-idp'

group :development, :test do
  gem 'rubocop'
end

group :development do
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'listen'
end
