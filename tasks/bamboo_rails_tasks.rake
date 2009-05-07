desc "Reset the test database and run the entire test suite, formatting results for the Bamboo CI Server."
task :bamboo do
  # Force us to be using the test environment so that we can use regular rake
  # tasks to manipulate the database.
  RAILS_ENV = ENV['RAILS_ENV'] = "test"
  Rake::Task["bamboo:all"].invoke
end

namespace :bamboo do
  task :all => [ :preflight, :test, :spec, :features ]

  task :preflight => [ :environment, "gems:build:force", "db:migrate:reset" ]

  task :test     => [ "ci:setup:testunit", "rake:test" ]
  task :spec     => [ "ci:setup:rspec", "spec:rcov" ]
  task :features => [ "ci:setup:cucumber", "rake:features" ]
end
