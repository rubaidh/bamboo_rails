desc "Reset the test database and run the entire test suite, formatting results for the Bamboo CI Server."
task :bamboo do
  # Force us to be using the test environment so that we can use regular rake
  # tasks to manipulate the database.
  RAILS_ENV = ENV['RAILS_ENV'] = "test"
  Rake::Task["bamboo:all"].invoke
end

namespace :bamboo do
  task :all => [ :preflight, :test, :spec, :features ]

  task :preflight => [ "log:clear", :environment, "gems:build:force", "db:migrate:reset" ]

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
