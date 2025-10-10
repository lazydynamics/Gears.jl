# [Clocks](@id architecture-clocks)

## Overview

Clocks provide a unified interface for time abstraction in Gears. They allow you to work with either real system time or controllable virtual time for simulations.

## Clock Interface

All clocks implement the `Clock` abstract type and must provide:

```julia
now(clock::Clock) -> Quantity{<:Number, 𝐓}
```

## Implementations

### MachineClock
Uses system time for real-time simulations.

```@docs; canonical=false
Gears.MachineClock
```

### VirtualClock  
Controllable time for deterministic simulations.

```@docs; canonical=false
Gears.VirtualClock
```

## Usage Examples

```@example clocks
using Gears


# Real-time clock
clock = MachineClock()
println(now(clock))  # Machine clock starts paused

# Virtual clock for simulations
clock = VirtualClock()
advance_time!(clock, 50ms)
println(now(clock))  # 0.05 s
```


