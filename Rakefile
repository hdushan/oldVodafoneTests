task :default => :tests

desc 'Run all tests'
task :tests => [:spec, 'jasmine:ci', :cucumber]

# rspec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--color"
end

# cucumber
require 'cucumber/rake/task'

require 'fileutils'

namespace :cucumber do
  Cucumber::Rake::Task.new(:default) do |t|
    t.cucumber_opts = "features --format pretty"
  end
end

task :cucumber => 'cucumber:default'

# ci
task :ci do
  puts '\nRunning CI task.'
  Rake::Task['tests'].invoke
  puts '\nDone.'
end

require 'jmeter-runner-gem'
desc "Start a server and run the JMeter driver against it."
task :benchmark do
  testRunner = JmeterRunnerGem::Test.new("localhost", 9393, 'bundle exec rackup', \
  "server_log", "server_error", "tnt.jmx", "tnt.jtl", "xml")
  testRunner.start()
end


# javascript compression
APP_FILE = 'app.rb'
APP_CLASS = 'Sinatra::Application'
require 'sinatra/assetpack/rake'

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

at_exit do
  if @server_pid && @server_pid!=0
    puts "Killing the server"
    Process.kill("KILL", @server_pid)
  end
end