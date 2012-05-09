require 'json'

module RoundRobin
  class Job < ActiveRecord::Base
    self.table_name = 'round_robin_jobs'

    def invoke_job
      update_attribute :invoked_at, Time.now
      return unless runnable?
      begin
        update_attributes(:started_at => Time.now, :finished_at => nil)
        klass = Module.const_get(parsed_handler["class"])
        args = parsed_handler["args"]
        klass.perform(*args)
      rescue  Exception => e

      ensure
        update_attribute(:finished_at, Time.now)
      end
    end

    def runnable?
      !skip && (every_n_hours.nil? || every_n_hours == 0 || invoked_at.nil? || invoked_at < every_n_hours.hours.ago)
    end

    private

    def parsed_handler
      @parsed_handler ||= JSON.parse(handler)
    end
  end
end
