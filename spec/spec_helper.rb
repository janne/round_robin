require 'rubygems'
require 'active_record'
gem 'sqlite3-ruby'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

ActiveRecord::Schema.define do
  create_table :round_robin_jobs, :force => true do |t|
    t.text     :handler
    t.datetime :started_at
    t.datetime :finished_at
    t.timestamps
  end
end
