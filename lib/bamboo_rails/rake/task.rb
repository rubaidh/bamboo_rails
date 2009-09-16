require 'ci/reporter/rake/cucumber'
require 'ci/reporter/rake/rspec'
require 'ci/reporter/rake/test_unit'

desc "Reset the test database and run the entire test suite, formatting results for the Bamboo CI Server."
task :bamboo do
  # Force us to be using the test environment so that we can use regular rake
  # tasks to manipulate the database.
  RAILS_ENV = ENV['RAILS_ENV'] = "test"
  Rake::Task["bamboo:all"].invoke
end

namespace :bamboo do
  task :all => [ :preflight, :test, :spec, :features ]

  task :preflight => [ :gems, "log:clear", :environment, :db ]

  task :gems do
    if Rake::Task.task_defined?("gems:build:force")
      Rake::Task["gems:build:force"].invoke
    else
      Rake::Task["gems:build"].invoke
    end
  end

  task :db do
    if defined?(ActiveRecord) && File.exist?(File.join(RAILS_ROOT, "config", "database.yml"))
      Rake::Task["db:migrate:reset"].invoke
    end
  end

  task :test => [ "ci:setup:testunit", "rake:test" ]

  task :spec do
    if Rake::Task.task_defined?("spec:rcov")
      Rake::Task["ci:setup:rspec"].invoke
      Rake::Task["spec:rcov"].invoke
    end
  end

  task :features do
    if Rake::Task.task_defined?("rake:features")
      Rake::Task["ci:setup:cucumber"].invoke
      Rake::Task["rake:features"].invoke
    end
  end
end
