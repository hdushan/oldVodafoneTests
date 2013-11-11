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
  server_thread = start_server()
  puts "\nServer started for benchmarking ...\n"
  Rake::Task['jmeter'].invoke
  puts "\nWaiting for Server thread to join ...\n"
  server_thread.kill
  server_thread.join
  puts "\nBenchmarking done. Server joined...\n"
end

def start_server()
  server_start_cmd = 'shotgun app.rb -o 0.0.0.0'
  server_thread = Thread.new { sh server_start_cmd }
  count = 0
  @server_pid = nil
  loop do
      sleep 1
      puts `ps -el | grep ruby`
      if `ps -el | grep ruby`.length>0
        @server_pid = `ps -el | grep ruby`.split(" ")[3].to_i
        break
      end
      count += 1
      break if @server_pid || count > 6
  end
  fail "Server PID not found after #{count} seconds" unless @server_pid
  puts "Server started, PID = #{@server_pid}"
  server_thread
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
  if @server_pid
    puts "Killing the server"
    `ps -o pid= --ppid #{@server_pid} | xargs kill`
    `kill #{@server_pid}`
  end
end