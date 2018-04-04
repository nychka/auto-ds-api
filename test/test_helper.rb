require 'simplecov'
SimpleCov.start do
  add_filter '/test'
  add_filter '/config'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Services', 'app/services'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def fixture_json(name)
    root = File.dirname(__FILE__)
    file = File.read("#{root}/fixtures/#{name}.json")
    JSON.parse(file)
  end
end
