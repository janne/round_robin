require 'rubygems'
require 'active_record'
require 'round_robin'
require 'pry'
gem 'sqlite3-ruby'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Schema.define do
  create_table :round_robin_jobs, :force => true do |t|
    t.text     :handler
    t.datetime :started_at, :finished_at, :invoked_at
    t.boolean  :skip
    t.integer  :every_n_hours
    t.timestamps
  end
end

class MyJob
  def perform(id)
  end
end

class RoundRobin::Worker
  def sleep_time
    0
  end
end
