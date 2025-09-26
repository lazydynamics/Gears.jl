# Architecture Overview

EnvironmentEngine is designed around three core abstractions that work together to provide flexible task scheduling in simulation environments:

## Core Concepts

### 1. **Clocks** - Time Abstraction
Clocks provide a unified interface for time, allowing you to work with either real system time or controllable virtual time for simulations.

### 2. **Jobs** - Task Definitions  
Jobs represent the actual work to be performed. There are three types:
- **Timed Jobs**: Execute at regular intervals (e.g., every 10ms)
- **ASAP Jobs**: Execute as soon as possible (highest priority)
- **Event Jobs**: Execute when data arrives on a channel

### 3. **Schedulers** - Job Coordination
Schedulers manage when jobs should be executed, coordinating between the clock and the jobs. Schedulers can be configured to run in a single thread or in multiple threads.

## Main Entry Points

The primary way users interact with EnvironmentEngine is through the `every()` function, which creates different types of jobs:

### Job Types

1. **Timed Jobs** - Execute at regular intervals
   ```julia
   every(10ms) do dt
       plan!(agent)
   end
   ```

2. **ASAP Jobs** - Execute as soon as possible (highest priority)
   ```julia
   every(asap) do
       process_urgent_task()
   end
   ```

3. **Event Jobs** - Execute when data arrives on a channel
   ```julia
   events = Channel{String}(Inf)
   every(events) do event
       handle_event(event)
   end
   ```

### Scheduler Control

- **`every(scheduler,interval)`** - Schedule tasks
- **`for_next(clock, duration)`** - Run the scheduler for a specific time period
- **`update!(scheduler)`** - Update the scheduler with the current time and execute all jobs that are scheduled to run within this time period

## Example Usage

```julia
clock = MachineClock()
scheduler = TickedScheduler(clock, 1.0ms)

# Schedule agent planning every 10ms
every(scheduler,10ms) do dt
    plan!(agent)
end

# Schedule environment updates every 1ms  
every(scheduler,1ms) do dt
    update!(environment)
end

# Handle urgent tasks as soon as possible
every(scheduler,asap) do
    process_urgent_events()
end

# Run the simulation for 5 seconds
for_next(clock, 5s) do
    update!(scheduler)  # Process all scheduled jobs
end
```

This creates an asynchronous agent-environment interaction loop where both components run at their own frequencies, with urgent tasks handled immediately, all coordinated by the scheduler.

## Architecture Principles

1. **Virtual Time First**: All scheduling operates in virtual time, which can optionally sync with real time
2. **Job Autonomy**: Jobs decide when to execute based on their own logic and the current time
3. **Scheduler Coordination**: The scheduler coordinates between clocks and jobs, calling `progress!()` on jobs at appropriate times
4. **Multiple Dispatch**: Different job types and schedulers can have specialized behaviors through Julia's multiple dispatch system

## Documentation Structure

- [C4 Model](@ref architecture-c4-model) - Complete C4 model showing all architecture levels
- [Clocks](@ref architecture-clocks) - Detailed documentation on clock implementations
- [Schedulers](@ref architecture-schedulers) - Detailed documentation on scheduler implementations  
- [Jobs](@ref architecture-jobs) - Detailed documentation on job types and implementations
