# [Basic Scheduling](@id tutorial-basic-scheduling)

Learn the fundamentals of job scheduling in Gears. This tutorial covers the core concepts you need to understand how jobs are scheduled and executed.

## The Scheduling Model

`Gears` schedules jobs based on the current time as provided by the active clock and scheduler. Jobs are scheduled to run at specific times, whenever an event is triggered, or just as soon as possible. The scheduler determines when each job should execute according to its configuration.
!!! note
    Before we dive into the basics of scheduling, let's cover the core concepts of clocks and schedulers. These concepts will be covered in more detail in the [Clocks and Time](@ref tutorial-clocks-time) and [Schedulers](@ref tutorial-schedulers) tutorials. For now, it is enough to know that:
    - A `Scheduler` is responsible for keeping a registry of jobs, and calling jobs when they are due.
    - A `Clock` is responsible for providing the current time. A `Scheduler` uses a `Clock` to determine when jobs should be executed.


## Core Functions

### `every()` - Schedule Jobs

The `every()` function is your primary tool for scheduling jobs:

```julia
# Schedule a job every 100 milliseconds
every(100ms) do dt
    println("Executed after $dt seconds")
end
```

The `dt` parameter represents the time elapsed since the last execution. Here, we have configured a job to run on a time interval, and the scheduler will execute the job every 100 milliseconds. A job that runs on a time interval is called a **timed job** and always takes a `dt` parameter, so the body can depend on the time elapsed since the last execution.

### `for_next()` - Run the Scheduler

Use `for_next()` to run the scheduler for a specific duration:

```julia
# Run the scheduler for 500 milliseconds
for_next(500ms) do
    update!()
end
```

### `update!()` - Process Jobs

`update!()` advances time and executes all jobs that are due:

```julia
update!()  # Process all scheduled jobs
```

## A Complete Example

Let's build a simple simulation that demonstrates basic scheduling:

```julia
using Gears

# Schedule a sensor reading every 50ms
every(50ms) do dt
    reading = rand() * 100
    println("Sensor reading: $(round(reading, digits=2))")
end

# Schedule a status report every 180ms
every(180ms) do dt
    println("Status report at $(now(global_clock()))")
end

# Run the simulation for 1 second
for_next(1.0s) do
    update!()
end
```

## Understanding the Output

Notice that:
- The sensor runs every 50ms (4 times per 200ms)
- The status report runs every 180ms
- Both jobs run independently

## Key Concepts

1. **Independent Jobs**: Each `every()` call creates a separate job that runs independently
2. **Synchronous Execution**: All jobs due at a given time are executed before time advances

## Next Steps

Now that you understand basic scheduling, you're ready to learn about:
- [Clocks and Time](@ref tutorial-clocks-time) - Control time in your simulations
- [Schedulers](@ref tutorial-schedulers) - Configure job execution behavior
- [Job Types](@ref tutorial-job-types) - Different ways to trigger jobs
