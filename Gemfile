ruby '2.4.3'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'
gem 'puma', '~> 3.7'
gem 'rack-cors'
gem 'sqlite3'
gem 'dotenv-rails'
gem 'faraday'
gem 'faraday_middleware'
gem 'acts_as_tree'
gem 'active_model_serializers'

group :development, :test, :staging do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
end

group :test do
  gem 'simplecov', require: false
  gem 'mocha'
end

group :development do
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', '~> 0.35.1'
  gem 'guard'
  gem 'guard-minitest'
end
