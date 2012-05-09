require 'spec_helper'
describe RoundRobin::Job do
  describe "#invoke_job" do
    before do
      @job = RoundRobin::Job.new :handler => {:class => "MyJob", :args => [1]}.to_json
    end
    it "performs the job" do
      MyJob.should_receive(:perform).with(1)
      @job.invoke_job
    end
    it "updates finished_at" do
      lambda{
        @job.invoke_job
      }.should change(@job, :finished_at).from(nil)
    end
    it "updates started_at" do
      lambda{
        @job.invoke_job
      }.should change(@job, :started_at).from(nil)
    end
    it "catches exceptions and updates started_at and finished_at attributes" do
      t1 = Time.now
      t2 = Time.now + 1
      Time.stub(:now).and_return(t1,t2)
      MyJob.should_receive(:perform).and_raise(Exception)
      @job.invoke_job
      @job.reload
      @job.started_at.should eql(t1)
      @job.finished_at.should eql(t2)
    end

    context "runnable? returns false" do
      before do
        @job.should_receive(:runnable?).and_return(false)
      end

      it "skips jobs marked with skip but updates the timestamps" do
        MyJob.should_not_receive(:perform)
        @job.invoke_job
      end

      it "updates invoked_at" do
        lambda { @job.invoke_job }.should change(@job, :invoked_at)
      end

      it "does'nt updates started_at" do
        lambda { @job.invoke_job }.should_not change(@job, :started_at)
      end

      it "doesn't updates finished_at" do
        lambda { @job.invoke_job }.should_not change(@job, :finished_at)
      end
    end

    describe "#runnable" do
      it "should normally run now" do
        @job.should be_runnable
      end

      it "should run if it has never been run before" do
        @job.update_attribute(:every_n_hours, 42)
        @job.should be_runnable
      end

      it "should not run if last run was less than 42 hours ago" do
        @job.update_attributes(:every_n_hours => 42, :invoked_at => 1.hour.ago)
        @job.should_not be_runnable
      end

      it "should run if last run was more than 42 hours ago" do
        @job.update_attributes(:every_n_hours => 42, :invoked_at => 50.hour.ago)
        @job.should be_runnable
      end

      it "should not run if skipped" do
        @job.update_attributes(:skip => true)
        @job.should_not be_runnable
      end
    end
  end
end
