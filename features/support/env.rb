require_relative "../../app"

require "capybara/cucumber"
require "rspec/expectations"

World do
  Capybara.app = Sinatra::Application
end