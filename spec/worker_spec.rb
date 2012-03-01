require 'spec_helper'
describe RoundRobin::Worker do
  describe "#work" do
    before do
      @worker = RoundRobin::Worker.new
      @worker.should_receive(:shutdown).and_return(true)
      RoundRobin.clear
    end

    it "should perform a job" do
      job = RoundRobin::Job.create(:handler => {:class => "MyJob", :args => [42]}.to_json)
      RoundRobin::Job.any_instance.should_receive(:invoke_job)
      @worker.work
    end
    it "should take the job with oldest started_at time" do
      job = RoundRobin::Job.create(:handler => {:class => "MyJob", :args => [0]}.to_json, :started_at => Time.now)
      old_job = RoundRobin::Job.create(:handler => {:class => "MyJob", :args => [1]}.to_json,:started_at => Time.now - 2000)
      MyJob.should_receive(:perform).with(1)
      @worker.work
    end
  end
end

