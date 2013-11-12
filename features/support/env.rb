require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.use_merging false
SimpleCov.start

require_relative "../../app"

require "capybara/cucumber"
require "rspec/expectations"

World do
  Capybara.app = Sinatra::Application
end