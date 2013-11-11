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

desc "Start a server and run the JMeter driver against it."
task :benchmark do
  puts "\nStarting server for benchmarking ...\n"
  start_server()
  puts "\nServer started for benchmarking ...\n"
  Rake::Task['jmeter'].invoke
  puts "\nBenchmarking done ...\n"
end

def start_server()
  @server_pid =Process.spawn('shotgun app.rb -o 0.0.0.0', out: "/dev/null", err: "/dev/null")
  puts "Server started, PID = #{@server_pid}"
end

desc "Run JMeter test."
task :jmeter => :install_jmeter do
  jmeter_test_script = "tnt.jmx"
  jmeter_test_results_file = "tnt.jtl"
  puts "\nClearing old JMeter test result file ...\n"
  sh "rm #{jmeter_test_results_file}"
  puts "\nRunning JMeter test ...\n"
  sh "./build/apache-jmeter-2.10/bin/jmeter -n -t #{jmeter_test_script} -l #{jmeter_test_results_file}"
  puts "\nJMeter test done ...\n"
end

task :install_jmeter => 'build/apache-jmeter-2.10/bin/jmeter'

file 'build/apache-jmeter-2.10/bin/jmeter' do
  puts "\nInstalling JMeter ...\n"
  Dir.chdir('build') do
    sh "curl http://apache.mirror.serversaustralia.com.au//jmeter/binaries/apache-jmeter-2.10.tgz | tar zxf -"
  end
  puts "\nJMeter install done ...\n"
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