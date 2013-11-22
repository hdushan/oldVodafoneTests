
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
      t.cucumber_opts = "features --format pretty"
    end
  end

  task :cucumber => 'cucumber:default'
end

safe_load('jmeter') do
  require 'jmeter-runner-gem'

  desc "Start a server and run the JMeter driver against it."
  task :benchmark do
    testRunner = JmeterRunnerGem::Test.new("localhost", 9393, 'bundle exec rackup', \
  "server_log", "server_error", "tnt.jmx", "tnt.jtl", "xml")
    testRunner.start()
  end

end


safe_load('jasmine') do
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
end