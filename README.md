# EnvironmentEngine

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://lazydynamics.github.io/EnvironmentEngine.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://lazydynamics.github.io/EnvironmentEngine.jl/dev/)
[![Build Status](https://github.com/lazydynamics/EnvironmentEngine.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/lazydynamics/EnvironmentEngine.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/lazydynamics/EnvironmentEngine.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/lazydynamics/EnvironmentEngine.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

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

## Installation

```julia
using Pkg
Pkg.add("EnvironmentEngine")
```

## Basic Example

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

## Clock Types

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

## Documentation

- [Getting Started](https://lazydynamics.github.io/EnvironmentEngine.jl/dev/getting_started/) - Quick setup and basic examples
- [API Reference](https://lazydynamics.github.io/EnvironmentEngine.jl/dev/api/) - Complete function documentation

## License

This package is licensed under MIT (see the LICENSE file).
