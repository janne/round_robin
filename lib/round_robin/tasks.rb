require 'round_robin'

namespace :round_robin do
  desc "Start a worker" do
    worker = RoundRobin::Worker.new
    Process.daemon(true)
    worker.work
  end

  desc "Start multiple workers"
  task :workers do
    threads = []
    ENV['COUNT'].to_i.times do
      threads << Thread.new do
        system "rake round_robin:work"
      end
    end
    threads.each { |thread| thread.join }
  end
end
