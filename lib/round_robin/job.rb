module RoundRobin
  class Job < ActiveRecord::Base
    self.table_name = 'round_robin_jobs'
  end
end
