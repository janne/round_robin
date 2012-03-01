require 'round_robin'

class MyJob
  def perform(id)
  end
end

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
end
