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
# task :ci do
#   puts 'Running CI task.'
#   Rake::Task['tests'].invoke
#   puts 'Done.'
# end

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