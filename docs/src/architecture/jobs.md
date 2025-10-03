# [Jobs](@id architecture-jobs)

## Overview

Jobs represent the actual work to be performed in EnvironmentEngine. There are three types of jobs, each with different execution characteristics.

## Job Interface

All jobs implement the `Job` abstract type and must provide:

```julia
progress!(job::Job, t::Quantity{<:Number, 𝐓})
```

```@docs
EnvironmentEngine.progress!
```

## Job Types

### TimedJob
Execute at regular intervals. Created with `every(scheduler, interval)`.

### AsapJob  
Execute as soon as possible (highest priority). Created with `every(scheduler, asap)`.

### EventJob
Execute when data arrives on a channel. Created with `every(scheduler, channel)`.

## Usage Examples

```julia
# Timed job - executes every 10ms
every(scheduler, 10ms) do dt
    plan!(agent)
end

# ASAP job - executes as soon as possible
every(scheduler, asap) do
    process_urgent_task()
end

# Event job - executes when data arrives
events = Channel{String}(Inf)
every(scheduler, events) do event
    handle_event(event)
end
```
