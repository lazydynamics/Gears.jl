# [Quick Start](@id quickstart)

Get EnvironmentEngine running in under 5 minutes! This tutorial shows you the simplest way to schedule and execute jobs.

## Installation

```julia
using Pkg
Pkg.add("EnvironmentEngine")
```

## Your First Scheduled Job

Here's the minimal example to get you started:

```julia
using EnvironmentEngine

# Schedule a job to run every 200 milliseconds
every(200ms) do dt
    println("Task executed at $(now(global_clock()))")
end

# Run the scheduler for 1 second
for_next(1s) do
    update!()
end
```

That's it! This will:
1. Schedule a job to print a message every 200ms
2. Run the scheduler for 1 second
3. Execute the scheduled task 5 times

## What Just Happened?

- `every(200ms)` creates a **timed job** that runs every 200 milliseconds
- `for_next(1s)` runs the scheduler for 1 second of simulated time
- `update!()` processes all scheduled jobs and advances time
- `now(global_clock())` gets the current time from the default clock

## Next Steps

Ready to learn more? Check out the [Basic Scheduling](@ref tutorial-basic-scheduling) tutorial to understand the fundamentals, or jump to any topic that interests you:

- [Basic Scheduling](@ref tutorial-basic-scheduling) - Learn job scheduling fundamentals
- [Clocks and Time](@ref tutorial-clocks-time) - Understand time control
- [Job Types](@ref tutorial-job-types) - Explore different job triggers
- [Schedulers](@ref tutorial-schedulers) - Configure job execution
- [Threading](@ref tutorial-threading) - Run jobs in parallel
