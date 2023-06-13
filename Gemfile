# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'glimmer-dsl-swt', '>= 4.17.4.1', '< 5.0.0.0'
gem 'glimmer-dsl-xml', '>= 1.3.2', '< 2.0.0'
gem 'glimmer-dsl-css', '>= 1.2.2', '< 2.0.0'

group :development do
  gem 'juwelier', '~> 2.4.9'
  gem 'rspec', '~> 3.5.0'
  gem 'coveralls', '= 0.8.23', require: false
  gem 'simplecov', '~> 0.16.1', require: nil
  gem 'simplecov-lcov', '~> 0.7.0', require: nil
  gem 'glimmer-cw-video', path: '.' # used to test running samples via glimmer command
end
