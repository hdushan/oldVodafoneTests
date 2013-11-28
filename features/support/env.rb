require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.use_merging false
SimpleCov.start

require_relative "../../app"

require "capybara/cucumber"
require "rspec/expectations"
require "cucumber/rspec/doubles"

path = ".env" + ( ["development"].include?(ENV['RACK_ENV']) ? "" : ".#{ENV['RACK_ENV']}")
Dotenv.load(path) if File.exists?(path)

World do
  Capybara.app = Sinatra::Application
end