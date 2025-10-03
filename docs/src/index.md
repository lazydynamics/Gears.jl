```@meta
CurrentModule = EnvironmentEngine
```

# EnvironmentEngine

A Julia package for scheduling tasks in simulation environments with precise timing control.

## Quick Start

```julia
using EnvironmentEngine

# Schedule a task every 200ms
every(200ms) do dt
    println("Task executed at $(now(global_clock()))")
end

# Run the scheduler for 1 second
for_next(1s) do
    update!()
end
```

## Features

- **Timed Jobs**: Execute tasks at regular intervals
- **ASAP Jobs**: Execute tasks as soon as possible  
- **Event Jobs**: Execute tasks when data arrives on channels
- **Multiple Clocks**: Machine time or controllable virtual time
- **Flexible Scheduling**: Global or custom schedulers
- **Multi-threading**: Parallel job execution

## Documentation

### Getting Started
- [Quick Start](@ref quickstart) - Get up and running in 5 minutes

### Tutorials
- [Tutorials](@ref tutorials) - Step-by-step learning guide
  - [Basic Scheduling](@ref tutorial-basic-scheduling) - Learn job scheduling fundamentals
  - [Clocks and Time](@ref tutorial-clocks-time) - Understand time control
  - [Job Types](@ref tutorial-job-types) - Explore different job triggers
  - [Schedulers](@ref tutorial-schedulers) - Configure job execution
  - [Threading](@ref tutorial-threading) - Run jobs in parallel

### User Guide
- [User Guide](@ref user-guide) - Complete reference documentation
  - [API Reference](@ref user-guide-api-reference) - Function and type documentation
  - [Sharp Bits](@ref user-guide-sharp-bits) - Learn about sharp bits

### Architecture
- [Architecture](@ref architecture) - Implementation details and design

### Index
```@index
```
