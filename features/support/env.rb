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
  Capybara.app = App.new(MegaMenuAPIClient.new, FulfilmentClient.new(PutsLogger.new, FULFILMENT_ROOT))
end

Capybara.javascript_driver = :poltergeist

Before do
  agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
  page.driver.add_header("User-Agent", agent)
  stub_desktop_mega_menu
end

Before('@mobile') do
  agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16"
  page.driver.add_header("User-Agent", agent)
  stub_mobile_mega_menu
end

After('@mobile') do
  puts "Clear browser driver after mobile scenario"
  page.reset_session!
end