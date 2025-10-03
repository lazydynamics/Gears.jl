# [Schedulers](@id tutorial-schedulers)

Schedulers are the core component that coordinates between a clock and a collection of jobs. This tutorial covers how to configure and customize schedulers for different use cases.

## What Are Schedulers?

Schedulers manage when jobs should be executed by:
- Tracking the current time from a clock
- Determining which jobs are due for execution
- Executing jobs in the correct order

Schedulers are used to orchestrate the execution of jobs in a simulation, and they can be passed to the `every()` function.

## Default Scheduler

When you use `every()` without specifying a scheduler, EnvironmentEngine uses a default scheduler with the global clock:

```julia
# Uses default scheduler with global clock
every(100ms) do dt
    println("Using default scheduler")
end
```

However, we recommend passing a scheduler to the `every()` function to get more control over the execution of jobs.

## TickedScheduler

The `TickedScheduler` is the main scheduler implementation. It divides time into discrete ticks and executes all jobs that are due within each tick. This is based on the [Game Loop Pattern](https://gameprogrammingpatterns.com/game-loop.html). The `TickedScheduler` takes a `Clock` and a tick rate. The `Clock` will be used as an abstract timekeeper, and the tick rate will be used to discretize time.

```@docs; canonical=false
EnvironmentEngine.TickedScheduler
```

### Basic TickedScheduler

A `TickedScheduler` can be created by associating a clock and a time interval between ticks. Then, a scheduler is passed to the `every()` function to schedule jobs on that scheduler, and we can use `for_next(clock, duration)` to run the simulation for a specific duration, given the clock.

```@example ticked_scheduler
using EnvironmentEngine

clock = VirtualClock()

# Create scheduler with 10ms tick rate
scheduler = TickedScheduler(clock, 10ms)

# Schedule jobs using the custom scheduler
every(scheduler, 50ms) do dt
    println("Job executed at $(now(clock))")
end

# Run the scheduler
for_next(clock, 200ms) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
```

### Tick Rate Selection

The tick rate determines how often the scheduler checks for jobs to execute. Let's take a look at the following three examples:

```@example ticked_scheduler
# Create a clock
clock = VirtualClock()
scheduler = TickedScheduler(clock, 1ms)

every(scheduler, 5ms) do dt
    println("Job executed at $(now(clock))")
    println("dt: $dt")
end

for_next(clock, 30ms) do
    update!(scheduler)
    advance_time!(clock, 1ms)
end
```
Here, we see that the job is executed at 5ms intervals. Time is discretized in 1ms increments. Let's see what happens if the tick rate is 10ms instead of 1ms.

```@example ticked_scheduler
clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms)

every(scheduler, 5ms) do dt
    println("Job executed at $(now(clock))")
    println("dt: $dt")
end

for_next(clock, 30ms) do
    update!(scheduler)
    advance_time!(clock, 1ms)
end
```
Now, we see that jobs are executed twice at 10ms intervals. This is because the `TickedScheduler` ticks whenever the current time modulo 10ms is zero, meaning that at time 10ms, the job is executed twice. Note that `dt` for these calls is still 5ms. The scheduler behavior therefore only determines the **order** in which jobs are executed, but not the internal **interval** that the job uses. This enforces deterministic behavior in the job execution, allowing reproducible simulations. In general, it is advised to take a ticking frequency that is higher than the job intervals, in order to match the true resolution as closely as possible.

## Scheduler Configuration

### Threading Support

Enable multi-threading for parallel job execution:

```@example ticked_scheduler
# Single-threaded (default)
scheduler = TickedScheduler(clock, 10ms)

# Multi-threaded
scheduler = TickedScheduler(clock, 10ms; threading=true);
```
The `TickedScheduler` supports multi-threading, and the `threading` keyword argument can be used to enable it. More details on threading can be found in the [Threading](@ref tutorial-threading) tutorial.

## Next Steps

Now that you understand schedulers, explore:
- [Job Types](@ref tutorial-job-types) - Explore different job triggers
- [Threading](@ref tutorial-threading) - Run jobs in parallel
- [User Guide](@ref user-guide) - Complete reference documentation
