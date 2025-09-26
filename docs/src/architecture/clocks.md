# [Clocks](@id architecture-clocks)

## Overview

Clocks provide a unified interface for time abstraction in EnvironmentEngine. They allow you to work with either real system time or controllable virtual time for simulations.

## Clock Interface

All clocks implement the `Clock` abstract type and must provide:

```julia
now(clock::Clock) -> Quantity{<:Number, 𝐓}
```

## Implementations

### MachineClock
Uses system time for real-time simulations.

### VirtualClock  
Controllable time for deterministic simulations.

## Usage Examples

```julia
# Real-time clock
clock = MachineClock()
println(now(clock))  # Current system time

# Virtual clock for simulations
clock = VirtualClock()
set_time!(clock, 0.0s)
advance_time!(clock, 50ms)
println(now(clock))  # 0.05 s
```


