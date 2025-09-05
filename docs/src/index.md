```@meta
CurrentModule = EnvironmentEngine
```

# EnvironmentEngine

A Julia package for scheduling tasks in simulation environments with precise timing control.

## Quick Start

```julia
using EnvironmentEngine

# Schedule a task every 20ms
every(20ms) do dt
    println("Task executed")
end

# Process scheduled jobs
update!()
```
This will schedule a task to run every 20 milliseconds. Whenever `update!` is called, `EnvironmentEngine` will sync the clock with the real time and execute the scheduled tasks. A common pattern is the following:

```julia
using EnvironmentEngine

# Schedule a task every 200ms
every(200ms) do dt
    println("Task executed at $(now(global_clock()))")
end

# Process scheduled jobs
for_next(5s) do
    update!()
end
```

## Features

- **Timed Jobs**: Execute tasks at regular intervals
- **ASAP Jobs**: Execute tasks as soon as possible  
- **Event Jobs**: Execute tasks when data arrives on channels
- **Multiple Clocks**: Machine time or controllable virtual time
- **Flexible Scheduling**: Global or custom schedulers

## Documentation

- [Getting Started](@ref user-guide-getting-started) - Quick setup and basic examples





```@index
```

```@autodocs
Modules = [EnvironmentEngine]
```