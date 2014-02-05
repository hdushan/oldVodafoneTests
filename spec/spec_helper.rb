$: << './lib'

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.use_merging false
SimpleCov.start

# rspec
require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require File.expand_path '../../app.rb', __FILE__

#matchers
require 'capybara'

def app
  App.new nil, nil
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

# Haml::Engine
require 'rspec-html-matchers'
def render(template, local_variables={})
  template = File.read(".#{template}")
  engine = Haml::Engine.new(template)
  @response = engine.render(double(Object.new, :haml => nil), local_variables)
end

def response
  @response
end

def page
  Capybara::Node::Simple.new(@response)
end


