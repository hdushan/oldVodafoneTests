require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.use_merging false
SimpleCov.start

require 'sass'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'phantomjs'
require 'rspec/mocks/standalone'

require_relative '../../app'
require_relative '../../lib/mega_menu/mega_menu_api_client'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :phantomjs => Phantomjs.path)
end

path = '.env' + ( ['development'].include?(ENV['RACK_ENV']) ? '' : ".#{ENV['RACK_ENV']}")
Dotenv.load(path) if File.exists?(path)

if ENV['RAILS_ENV'] == 'paas-qa'
  puts 'In PAAS QA'
  Capybara.app_host = "http://trackandtrace.qa.np.syd.services.vodafone.com.au"
  Capybara.default_driver    = :poltergeist
  Capybara.run_server = false
else
  puts 'In LOCAL'
  Capybara.app = App.new(MegaMenuAPIClient.new, double('ff_client'))
end

Capybara.javascript_driver = :poltergeist