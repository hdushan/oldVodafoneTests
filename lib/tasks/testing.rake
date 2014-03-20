
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
    t.rspec_opts = "--color --format documentation"
  end
end

safe_load('cucumber') do
  # cucumber
  require 'cucumber/rake/task'

  require 'fileutils'

  namespace :cucumber do
    Cucumber::Rake::Task.new(:default) do |t|
      t.cucumber_opts = "features --tags ~@ignore --format pretty --format json -o cucumber.json"
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
      server_address = "trackandtrace.qa.np.syd.services.vodafone.com.au"
      server_port = "80"
      server_url = "tracking"
      warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
      testRunner = JmeterRunnerGem::Test.new(server_address, server_port, "performance/tnt.jmx", "tnt_new.jtl", "xml", warmup_url)
      testRunner.start()
    else
      puts "Running on LOCAL"
      server_protocol = "http"
      server_address = "localhost"
      server_port = "9394"
      server_url = "tracking"
      warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
      testRunner = JmeterRunnerGem::Test.new(server_address, server_port, "performance/tnt.jmx", "tnt_new.jtl", "xml", warmup_url,
      true, 'bundle exec rackup', "server_log", "server_error", )
      testRunner.start()
    end
  end
  task :stress do
    puts "Running Stress Test (Peak Load)"
    server_protocol = "http"
    server_address = "trackandtrace.load-test.np.syd.services.vodafone.com.au"
    server_port = "80"
    server_url = "tracking"
    warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
    time_now=Time.now
    testRunner = JmeterRunnerGem::Test.new(server_address, server_port, "performance/tntLoadTest_stress.jmx", "tnt_stress_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl", "xml", warmup_url)
    testRunner.start()
  end
  task :normalload do
    puts "Running Load Test (Normal Load)"
    server_protocol = "http"
    server_address = "trackandtrace.load-test.np.syd.services.vodafone.com.au"
    server_port = "80"
    server_url = "tracking"
    warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
    time_now=Time.now
    testRunner = JmeterRunnerGem::Test.new(server_address, server_port, "performance/tntLoadTest_normal.jmx", "tnt_normal_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl", "xml", warmup_url)
    testRunner.start()
  end
  task :normalloadloose do
    puts "Running Load Test (Normal Load) in Loose validation mode"
    server_protocol = "http"
    server_address = "trackandtrace.load-test.np.syd.services.vodafone.com.au"
    server_port = "80"
    server_url = "tracking"
    warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
    time_now=Time.now
    testRunner = JmeterRunnerGem::Test.new(server_address, server_port, "performance/tntLoadTest_normal_loose.jmx", "tnt_normal_loose_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl", "xml", warmup_url)
    testRunner.start()
  end
  task :prodstress do
    puts "Running on PROD"
    server_protocol = "http"
    server_address = "trackandtrace.prod.paas.services.vodafone.com.au"
    server_port = "80"
    server_url = "tracking"
    warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
    time_now=Time.now
    testRunner = JmeterRunnerGem::Test.new(server_address, server_port, "performance/tntLoadTest_prodstress.jmx", "tnt_prodstress_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl", "xml", warmup_url)
    testRunner.start()
  end

end


safe_load('jasmine') do
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
end
