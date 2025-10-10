# [Schedulers](@id architecture-schedulers)

## Overview

Schedulers distribute time to jobs and manage when jobs should be executed, coordinating between the clock and the jobs. They can be configured to run in a single thread or in multiple threads.

## Scheduler Interface

All schedulers implement the `Scheduler` abstract type and must provide:

```julia
schedule!(scheduler::Scheduler, job::Job)
update!(scheduler::Scheduler)
```

```@docs
Gears.schedule!
Gears.update!
```




## Implementations

### TickedScheduler
Discretizes time into ticks and executes jobs within each tick. Provides deterministic execution timing.

## Usage Examples

```julia
clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms)

# Schedule jobs
every(scheduler, 30ms) do dt
    println("Timed job: $(now(clock))")
end

# Run scheduler
for_next(clock, 100ms) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
```
