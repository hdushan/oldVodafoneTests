require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.use_merging false
SimpleCov.start

# rspec
require 'rspec'
require 'rack/test'
require File.expand_path '../../app.rb', __FILE__

def app
  App.new nil, nil, nil
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

# Haml::Engine
require 'rspec-html-matchers'
def render(template, local_variables={})
  template = File.read(".#{template}")
  engine = Haml::Engine.new(template)
  @response = engine.render(Object.new, local_variables)
end

def response
  @response
end

def httparty_response(filename)
  parsed_response = HTTParty::Parser.call(File.read(filename), :json)
  OpenStruct.new(parsed_response: parsed_response, code: 200)
end