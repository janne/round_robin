Round Robin
===========

A library for running background jobs over and over again in a round robin fashion.

Consists of two parts:

* A rake task to start workers
* A ruby library for adding, removing, querying and processing jobs

Overview
--------

A Round Robin Job may be any Ruby class which responds to the method `perform`.

``` ruby
class SearchJob
  def self.perform(search_id)
    search = Search.find(search_id)
    # perform the search
  end
end

RoundRobin.add(SearchJob, 1)
RoundRobin.add(SearchJob, 2)
RoundRobin.add(SearchJob, 3)
```

Now fire up two workers with:

    COUNT=2 rake round_robin:workers

The two workers workers will take one job at a time each and process them in order.

The workers will be persisted and will be kept even after a restart of the
server. Typically in a Rails project a `RoundRobin.add` can be called in an
`after_create` callback and similarly a `RoundRobin.remove` may be called
`after_destroy`.

Round Robin is inspired by Resque and DelayedJob.
