require 'spec_helper'
describe RoundRobin do
  describe "#add" do
    it "should add a job when calling add" do
      lambda do
        RoundRobin.add(MyJob, 42)
      end.should change(RoundRobin::Job, :count).by(1)
    end

    it "should return a job" do
      job = RoundRobin.add(MyJob, 42)
      job.should be_a(RoundRobin::Job)
      job.id.should_not be_blank
    end
  end

  describe "#clear" do
    it "should remove all jobs" do
      RoundRobin::Job.create(:handler => {})
      RoundRobin::Job.create(:handler => {})
      lambda do
        RoundRobin.clear
      end.should change(RoundRobin::Job, :count).to(0)
    end
  end
end
