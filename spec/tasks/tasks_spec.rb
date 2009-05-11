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

  describe "any bamboo task invocation", :shared => true do
    it "should set RAILS_ENV to 'test'" do
      ENV["RAILS_ENV"].should == "test"
    end

    it "should clear the log files" do
      @tasks_run.should include("log:clear")
    end

    it "should set up the Rails environment" do
      @tasks_run.should include("environment")
    end

    it "should build any vendor gems" do
      @tasks_run.should include("gems:build")
    end

    it "should set up the Test::Unit ci_reporter reports" do
      @tasks_run.should include("ci:setup:testunit")
    end

    it "should run the Test::Unit tests" do
      @tasks_run.should include("test")
    end
  end

  describe "running the 'bamboo' task" do
    describe "without any RSpec specs" do
      before(:each) do
        Rake::Task['bamboo'].invoke
      end

      it_should_behave_like "any bamboo task invocation"

      it "should not setup the RSpec reports" do
        @tasks_run.should_not include("ci:setup:rspec")
      end

      it "should not run the spec task" do
        @tasks_run.should_not include("spec:rcov")
      end
    end

    describe "without any Cucumber features" do
      before(:each) do
        Rake::Task['bamboo'].invoke
      end

      it_should_behave_like "any bamboo task invocation"

      it "should not setup the Cucumber reports" do
        @tasks_run.should_not include("ci:setup:cucumber")
      end

      it "should not run the features task" do
        @tasks_run.should_not include("features")
      end
    end

    describe "with RSpec specs" do
      before(:each) do
        [
          "ci:setup:rspec", "spec:rcov"
        ].each do |task_name|
          task task_name do
            @tasks_run[task_name] = true
          end
        end
        Rake::Task['bamboo'].invoke
      end

      it_should_behave_like "any bamboo task invocation"

      it "should setup the RSpec reports" do
        @tasks_run.should include("ci:setup:rspec")
      end

      it "should run the spec task" do
        @tasks_run.should include("spec:rcov")
      end
    end

    describe "with Cucumber features" do
      before(:each) do
        [
          "ci:setup:cucumber", "features"
        ].each do |task_name|
          task task_name do
            @tasks_run[task_name] = true
          end
        end
        Rake::Task['bamboo'].invoke
      end

      it_should_behave_like "any bamboo task invocation"

      it "should setup the Cucumber reports" do
        @tasks_run.should include("ci:setup:cucumber")
      end

      it "should run the features task" do
        @tasks_run.should include("features")
      end
    end
  end

end