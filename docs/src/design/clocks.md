# Clock System Design

## Overview

The clock system provides a unified interface for time measurement while supporting multiple implementations for different use cases. All clocks implement the same interface, allowing seamless switching between real-time and simulation modes.

## Clock Interface

```julia
abstract type Clock end

function now(clock::Clock)
    # Returns current time as Quantity{<:Number, 𝐓}
    # Must be implemented by concrete clock types
end
```

## Clock Implementations

### MachineClock
Real-time clock implementation for production systems.

**Characteristics:**
- Uses system time as time source
- Monotonic time progression
- Suitable for real-time robotics applications
- Time cannot be controlled or manipulated

**Implementation:**
```julia
struct MachineClock <: Clock end

function now(clock::MachineClock)
    return time()u"s"
end
```

### VirtualClock
Controllable clock implementation for simulation and testing.

**Characteristics:**
- Manual time progression control
- Deterministic time behavior
- Suitable for simulation environments
- Time can be advanced, set, or reset

**Core Methods:**
- `advance_time!(clock, dt)`: Increment clock by specified duration
- `set_time!(clock, time)`: Set clock to specific time
- `reset!(clock)`: Reset clock to zero

## Time Representation

All clocks use Unitful.jl for time representation:
- Time values are `Quantity{<:Number, 𝐓}` types
- Supports all standard time units (s, ms, μs, etc.)
- Type-safe time arithmetic and comparisons
- Automatic unit conversion and validation

## Clock Configuration

### Default Clock
- System automatically creates default clock instance
- Can be configured or replaced at runtime
- Scheduler uses configured clock for time queries

### Clock Switching
- Scheduler can switch between clock implementations
- No impact on registered jobs
- Useful for transitioning between real-time and simulation modes

## Use Cases

### Production Systems
- Use MachineClock for real-time operation
- Provides accurate system time measurement
- Suitable for hardware control loops

### Simulation Environments
- Use VirtualClock for controlled time progression
- Enables deterministic simulation behavior
- Useful for testing and debugging

### Testing
- Inject VirtualClock for unit tests
- Control time progression for test scenarios
- Ensure reproducible test results
