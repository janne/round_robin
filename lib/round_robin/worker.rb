module RoundRobin
  class Worker
    attr_accessor :shutdown

    def work
      begin
        RoundRobin::Job.order("started_at").limit(1).first.try(:invoke_job)
        sleep sleep_time
      end while not shutdown
    end

    private

    def sleep_time
      1
    end
  end
end
