require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'rake'

describe "Rake tasks" do
  before(:each) do
    @rake = Rake.application = Rake::Application.new
    load File.join(File.dirname(__FILE__), '..', '..', 'tasks', 'bamboo_rails_tasks.rake')
    @tasks_run = {}

    [
      "log:clear", "environment", "gems:build", "ci:setup:testunit", "test"
    ].each do |task_name|
      task task_name do
        @tasks_run[task_name] = true
      end
    end
  end

  after(:each) do
    Rake.application = nil

    # Clear up definitions of RAILS_ENV, both from the environment, and that
    # pesky costant that's been declared.
    ENV.delete "RAILS_ENV"
    Object.send :remove_const, :RAILS_ENV
  end

  describe "running the 'bamboo' task" do
    it "should work" do
      Rake::Task['bamboo'].invoke.should be_true
    end

    it "should set RAILS_ENV to 'test'" do
      Rake::Task['bamboo'].invoke
      ENV["RAILS_ENV"].should == "test"
    end

    it "should clear the log files" do
      Rake::Task['bamboo'].invoke
      @tasks_run["log:clear"].should be_true
    end

    it "should set up the Rails environment" do
      Rake::Task['bamboo'].invoke
      @tasks_run["environment"].should be_true
    end

    it "should build any vendor gems" do
      Rake::Task['bamboo'].invoke
      @tasks_run["gems:build"].should be_true
    end

    it "should set up the Test::Unit ci_reporter reports" do
      Rake::Task['bamboo'].invoke
      @tasks_run["ci:setup:testunit"].should be_true
    end

    it "should run the Test::Unit tests" do
      Rake::Task['bamboo'].invoke
      @tasks_run["test"].should be_true
    end
  end
end