require 'json'

module RoundRobin
  class Job < ActiveRecord::Base
    self.table_name = 'round_robin_jobs'

    def invoke_job
      begin
        update_attributes(:started_at =>  Time.now, :finished_at => nil)
        klass = Module.const_get(parsed_handler["class"])
        args = parsed_handler["args"]
        klass.perform(*args) unless skip
      rescue  Exception => e

      ensure
        update_attribute(:finished_at, Time.now)
      end
    end


    private
    def parsed_handler
      @parsed_handler ||= JSON.parse(handler)
    end
  end
end
