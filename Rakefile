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

desc "Start a server and run the JMeter driver against it."
task :benchmark do
  puts "\nStarting server for benchmarking ...\n"
  @server_port = 9393
  start_server(@server_port)
  puts "\nServer started for benchmarking ...\n"
  Rake::Task['jmeter'].invoke
  puts "\nBenchmarking done ...\n"
end

def start_server(port)
  @server_pid =Process.spawn("bundle exec rackup -p #{port}", out: "server_log", err: "server_error")
  puts "Server started, PID = #{@server_pid}"
end

desc "Run JMeter test."
task :jmeter => :install_jmeter do
  jmeter_test_script = "tnt.jmx"
  jmeter_test_results_file = "tnt.jtl"
  results_format = "xml"
  server_port = @server_port
  server_address = "localhost"
  puts "\nClearing old JMeter test result file ...\n"
  FileUtils.rm_f(jmeter_test_results_file)
  puts "\nRunning JMeter test ...\n"
  sh "./build/apache-jmeter-2.10/bin/jmeter -n -JPORT=#{server_port} -JSERVER=#{server_address} -Jjmeter.save.saveservice.output_format=#{results_format} -t #{jmeter_test_script} -l #{jmeter_test_results_file}"
  puts "\nJMeter test done ...\n"
end

task :install_jmeter => 'build/apache-jmeter-2.10/bin/jmeter'

file 'build/apache-jmeter-2.10/bin/jmeter' do
  puts "\nInstalling JMeter ...\n"
  FileUtils.mkdir_p 'build'
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