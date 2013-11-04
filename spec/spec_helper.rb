# rspec
require 'rspec'
require 'rack/test'
require File.expand_path '../../app.rb', __FILE__

def app
  Sinatra::Application
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
