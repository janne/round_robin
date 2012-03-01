require 'round_robin/worker'
require 'round_robin/job'

module RoundRobin
  def self.add(klass, *args)
    json = {:class => klass, :args => args}.to_json
    RoundRobin::Job.create(:handler => json)
  end

  def self.clear
    RoundRobin::Job.destroy_all
  end
end
