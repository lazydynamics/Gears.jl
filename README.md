# Gears

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://lazydynamics.github.io/Gears.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://lazydynamics.github.io/Gears.jl/dev/)
[![Build Status](https://github.com/lazydynamics/Gears.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/lazydynamics/Gears.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/lazydynamics/Gears.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/lazydynamics/Gears.jl)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
<p align="left">
  <img src="logo.png" alt="Gears Logo" height="128">
</p>

A Julia package for scheduling tasks in simulation environments with precise timing control.

## Quick Start

```julia
using Gears

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
Pkg.add("Gears")
```

## Features

- **Timed Jobs**: Execute tasks at regular intervals
- **ASAP Jobs**: Execute tasks as soon as possible  
- **Event Jobs**: Execute tasks when data arrives on channels
- **Multiple Clocks**: Machine time or controllable virtual time
- **Flexible Scheduling**: Global or custom schedulers
- **Multi-threading**: Parallel job execution

## Documentation

- [Getting Started](https://lazydynamics.github.io/Gears.jl/dev/) - Quick setup and basic examples
- [Tutorials](https://lazydynamics.github.io/Gears.jl/dev/tutorials/) - Step-by-step learning guide
- [API Reference](https://lazydynamics.github.io/Gears.jl/dev/user_guide/api_reference/) - Complete function documentation


## License

This project is licensed under the GNU Affero General Public License v3.0 - see the LICENSE file for details.

For companies and organizations that require different licensing terms, alternative licensing options are available from [Lazy Dynamics](https://www.lazydynamics.com). Please [contact](mailto:info@lazydynamics.com) Lazy Dynamics for more information about licensing options that may better suit your specific needs and use cases.