require 'app-version'

Dir.glob('lib/tasks/*.rake').each { |file| load file }
$: << './lib'

task :default => [:tests, 'version:create']

desc 'Run all tests'
task :tests => [:spec, 'assetpack:build', 'jasmine:ci', :cucumber]

# ci
task :ci do
  puts '\nRunning CI task.'
  ENV['RAILS_ENV'] = nil
  Rake::Task['tests'].invoke
  Rake::Task['version:create'].invoke
  puts '\nDone.'
end

# qa
task :qa do
  puts '\nRunning QA task.'
  ENV['RAILS_ENV'] = 'paas-qa'
  Rake::Task['cucumber'].invoke
  ENV['RAILS_ENV'] = nil
  puts '\nDone.'
end

task :jshint do
  # jshint
  require 'jshintrb/jshinttask'

  Jshintrb::JshintTask.new :jshint do |t|
    t.pattern = 'assets/javascripts/*.js'
    t.options = :defaults
    t.globals = [ "n", "$" ]
  end
end

# javascript compression
APP_FILE = 'app.rb'
APP_CLASS = 'Sinatra::Application'
require 'sinatra/assetpack/rake'

at_exit do
  if @server_pid && @server_pid!=0
    puts "Killing the server"
    Process.kill("KILL", @server_pid)
  end
end
