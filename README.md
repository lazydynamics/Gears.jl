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

# Schedule a task every 200 milliseconds
every(200ms) do dt
    println("Task executed at $(now(global_clock()))")
end

# Run the scheduler for 1 second
for_next(1s) do
    update!()
end
```

## Installation

```julia
using Pkg
Pkg.add("EnvironmentEngine")
```

## Features

- **Timed Jobs**: Execute tasks at regular intervals
- **ASAP Jobs**: Execute tasks as soon as possible  
- **Event Jobs**: Execute tasks when data arrives on channels
- **Multiple Clocks**: Machine time or controllable virtual time
- **Flexible Scheduling**: Global or custom schedulers
- **Multi-threading**: Parallel job execution

## Documentation

- [Getting Started](https://lazydynamics.github.io/EnvironmentEngine.jl/dev/) - Quick setup and basic examples
- [Tutorials](https://lazydynamics.github.io/EnvironmentEngine.jl/dev/tutorials/) - Step-by-step learning guide
- [API Reference](https://lazydynamics.github.io/EnvironmentEngine.jl/dev/user_guide/api_reference/) - Complete function documentation
