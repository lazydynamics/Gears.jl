# [Getting started](@id user-guide-getting-started)

EnvironmentEngine is a Julia package for scheduling jobs in simulation environments. It provides a simple API for scheduling different types of jobs with various timing strategies.

## Quick Start

The simplest way to use EnvironmentEngine is with the default scheduler and clock. This will schedule a job to run every 200 milliseconds, which prints to the console every time it is executed. We can then trigger the execution of the scheduled jobs for a certain duration by wrapping `update!` in a `for_next` loop.

```julia
using EnvironmentEngine

# Schedule a job to run every 200 milliseconds
every(200ms) do dt
    println("Job executed after $dt seconds (global time: $(now(global_clock())))")
end

# Update the scheduler to process jobs
for_next(1000ms) do
    update!()
end
```


## Basic Example 

We can have different triggers for the execution of jobs. For example, we can schedule a job to run every 50 milliseconds, and another job to run as soon as possible. We can also schedule a job to run whenever an event is triggered. We use [`Channel`](https://docs.julialang.org/en/v1/base/parallel/#Base.Channel)s to trigger events.

```julia
using EnvironmentEngine

# Schedule different types of jobs
every(3ms) do dt
    println("Timed job: $(now(global_clock()))")
    # Irregularly send events
    if rand() < 0.5
        put!(events, "Event $(rand())")
    end
end

# Run this as often and soon as possible
every(asap) do
    println("ASAP job executed")
end

# Create a channel for event-driven jobs
events = Channel{String}(Inf)

# Run this when an event is received
every(events) do event
    println("Event received: $event")
end

# Simulate time progression
for_next(20ms) do
    update!()
end
```

Wow! That sure did something! As we can see, the jobs are executed exactly as we scheduled them. Let's recap what we learned so far:

- We can use `every(time)` to schedule a job at a regular interval.
- We can use `every(asap)` to schedule a job to run as soon as possible.
- We can use `every(channel)` to schedule a job to run when an event is received on a channel.
- We can use `for_next(time)` to run the scheduler for a certain duration.
- We can use `update!()` to update the scheduler and execute the scheduled jobs.

Notice that `asap` jobs execute multiple times between timed jobs, as we can expect. However, if we look closely, we can see that they execute exactly 3 times between every timed job. However, this behavior is controllable, and can be configured by using different clocks and schedulers. Let's look into that next.

## Clocks and Schedulers

Clocks and schedulers are the core components that control the timing and execution of jobs. Clocks are responsible for providing the time, and schedulers are responsible for scheduling jobs. We can use different clocks and schedulers to control the timing and execution of jobs.


## Clock Types

There are two types of clocks, `MachineClock` and `VirtualClock`. `MachineClock` uses the system time, and `VirtualClock` uses a controlled time for simulations.

### Machine Clock
Uses system time:

```julia
clock = MachineClock()
println(now(clock))  # Current system time
```

### Virtual Clock
Controlled time for simulations:

```julia
clock = VirtualClock()
set_time!(clock, 0.0s)
advance_time!(clock, 50ms)
println(now(clock))  # 0.05 s
```
As we can see, `VirtualClock` can be controlled by calling `set_time!` and `advance_time!`, and can be used to debug or test code.

### Schedulers

A scheduler is responsible for maintaining a set of jobs to be executed. A determinisic example of a scheduler is the `TickedScheduler`, which has a fixed tick rate, and discretizes time accordingly. The `TickedScheduler` waits until the next tick is available, and then executes all the jobs that are scheduled to run within this tick. 

```julia
clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms)
```

## Back to our example

Now that we've leaned about clocks and schedulers, we can use them to get a finer control over timing and job execution. Let's look at our example again.

```julia
clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms)

every(scheduler, 30ms) do dt
    println("Timed job: $(now(clock))")
end

for_next(clock, 100ms) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
```

As we can see, clocks and schedulers plug into the `every` and `for_next` functions seamlessly, and give additional control over timing and job execution, apart from the default behavior.
