
def safe_load(name)
  begin
    yield
  rescue LoadError
    task name.to_sym do
      abort "#{name} is not available. You need to install a corresponding gem first"
    end
  end
end

def run_load_test(server_protocol, server_address, server_port, server_url, loadtest_path, loadtest_result_path, loadtest_result_format)
  warmup_url = server_protocol + "://" + server_address + ":" + server_port + "/" + server_url
  testRunner = JmeterRunnerGem::Test.new(server_address, server_port, loadtest_path, loadtest_result_path, loadtest_result_format, warmup_url)
  testRunner.start()
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

  task :stress do
    puts "Running Stress Test (Peak Load)"
    time_now=Time.now
    loadtest_script = "performance/tntLoadTest_stress.jmx"
    result_file = "tnt_stress_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl"
    run_load_test("http", "trackandtrace.load-test.np.syd.services.vodafone.com.au", "80", "tracking", loadtest_script, result_file, "xml")
  end
  task :stressloose do
    puts "Running Stress Test (Peak Load) in Loose validation mode"
    time_now=Time.now
    loadtest_script = "performance/tntLoadTest_stress_loose.jmx"
    result_file = "tnt_stress_loose_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl"
    run_load_test("http", "trackandtrace.load-test.np.syd.services.vodafone.com.au", "80", "tracking", loadtest_script, result_file, "xml")   
  end
  task :normalload do
    puts "Running Load Test (Normal Load)"
    time_now=Time.now
    loadtest_script = "performance/tntLoadTest_normal.jmx"
    result_file = "tnt_normal_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl"
    run_load_test("http", "trackandtrace.load-test.np.syd.services.vodafone.com.au", "80", "tracking", loadtest_script, result_file, "xml")
  end
  task :normalloadloose do
    puts "Running Load Test (Normal Load) in Loose validation mode"
    time_now=Time.now
    loadtest_script = "performance/tntLoadTest_normal_loose.jmx"
    result_file = "tnt_normal_loose_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl"
    run_load_test("http", "trackandtrace.load-test.np.syd.services.vodafone.com.au", "80", "tracking", loadtest_script, result_file, "xml")
  end
  task :prodstress do
    puts "Running on PROD (Peak Load)"
    time_now=Time.now
    loadtest_script = "performance/tntLoadTest_prodstress.jmx"
    result_file = "tnt_prodstress_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl"
    run_load_test("http", "www.vodafone.com.au", "80", "tracking", loadtest_script, result_file, "xml")
  end
  task :prodstressloose do
    puts "Running on PROD (Peak Load) in Loose validation mode"
    time_now=Time.now
    loadtest_script = "performance/tntLoadTest_prodstress_loose.jmx"
    result_file = "tnt_prodstressloose_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl"
    run_load_test("http", "www.vodafone.com.au", "80", "tracking", loadtest_script, result_file, "xml")
  end
  task :prodlowload do
    puts "Running on PROD (Low Load)"
    time_now=Time.now
    loadtest_script = "performance/tntLoadTest_prod_low_load.jmx"
    result_file = "tnt_prod_low_load_" + time_now.strftime("%d%m%y_%H%M%S") + ".jtl"
    run_load_test("http", "www.vodafone.com.au", "80", "tracking", loadtest_script, result_file, "xml")
  end

end


safe_load('jasmine') do
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
end
