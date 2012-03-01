require 'spec_helper'
describe RoundRobin::Worker do
  describe "#work" do
    before do
      @worker = RoundRobin::Worker.new
      RoundRobin.clear
    end

    it "should perform a job" do
      job = RoundRobin::Job.create(:handler => {:class => "MyJob", :args => [42]}.to_json)
      @worker.should_receive(:shutdown).and_return(true)
      RoundRobin::Job.any_instance.should_receive(:invoke_job)
      @worker.work
    end
  end
end

