module RoundRobin
  class Worker
    attr_accessor :shutdown
    def work
      begin
        RoundRobin::Job.first.invoke_job
      end while not shutdown
    end
  end
end
