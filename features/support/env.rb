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

require_relative '../../spec/puts_logger'
require_relative '../../app'
require_relative '../../lib/mega_menu/mega_menu_api_client'

FULFILMENT_ROOT = 'http://fake-fulfilment.com.au/v1'

Capybara.register_driver :poltergeist do |app|
  options = {
          :js_errors => true,
          :phantomjs_options => ['--load-images=no', '--disk-cache=false', '--local-storage-quota=0', '--max-disk-cache-size=0', '--local-storage-path=""'],
      }
  Capybara::Poltergeist::Driver.new(app, :phantomjs => Phantomjs.path, :timeout => 40)
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
  Capybara.app = App.new('127.0.0.1', MegaMenuAPIClient.new, FulfilmentClient.new(PutsLogger.new, FULFILMENT_ROOT))
end

Capybara.javascript_driver = :poltergeist

Before do
  page.driver.browser.resize(1200, 800)
  stub_mega_menu
end

Before('@mobile') do
  page.driver.browser.resize(320, 480)
  stub_mega_menu
end