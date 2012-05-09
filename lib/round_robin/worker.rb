module RoundRobin
  class Worker
    attr_accessor :shutdown

    def work
      begin
        RoundRobin::Job.order("invoked_at").limit(1).first.try(:invoke_job)
        sleep sleep_time
      end while not shutdown
    end

    def pid
      Process.pid
    end

    private

    def sleep_time
      1
    end
  end
end
