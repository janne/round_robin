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
  end
end
