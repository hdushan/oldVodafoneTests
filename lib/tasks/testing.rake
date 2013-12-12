
def safe_load(name)
  begin
    yield
  rescue LoadError
    task name.to_sym do
      abort "#{name} is not available. You need to install a corresponding gem first"
    end
  end
end

safe_load('spec') do
  # rspec
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--color"
  end
end

safe_load('cucumber') do
  # cucumber
  require 'cucumber/rake/task'

  require 'fileutils'

  namespace :cucumber do
    Cucumber::Rake::Task.new(:default) do |t|
      t.cucumber_opts = "features --format pretty --format json -o cucumber.json"
    end
  end

  task :cucumber => 'cucumber:default'
end

safe_load('jmeter') do
  require 'jmeter-runner-gem'

  desc "Start a server (if in local mode) and run the JMeter driver against it."
  task :benchmark do
    if ENV['RAILS_ENV'] == 'paas-qa'
      puts "Running on PAAS-QA"
      server_protocol = "http"
      server_address = "trackandtrace-qa.np.syd.services.vodafone.com.au"
      server_port = "80"
      server_url = "tnt"
      warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
      testRunner = JmeterRunnerGem::Test.new(server_address, server_port, "tnt.jmx", "tnt_new.jtl", "xml", warmup_url)
      testRunner.start()
    else
      puts "Running on LOCAL"
      server_protocol = "http"
      server_address = "localhost"
      server_port = "9393"
      server_url = "tnt"
      warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
      testRunner = JmeterRunnerGem::Test.new(server_address, server_port, "tnt.jmx", "tnt_new.jtl", "xml", warmup_url,
      true, 'bundle exec rackup', "server_log", "server_error", )
      testRunner.start()
    end
  end

end


safe_load('jasmine') do
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
end
