# [Clocks and Time](@id tutorial-clocks-time)

Time management is fundamental to `EnvironmentEngine`. If you've been following along the tutorials, you have already scheduled tasks at regular intervals. In this tutorial, we will cover how time is being managed and how you can control it for simulations.

## Time Abstraction

`EnvironmentEngine` abstracts time through **Clocks**. Clocks provide a unified interface for getting the current time, whether you're working with real system time or controllable simulation time. Under the hood, `EnviornmentEngine` will call the `now` function on the active clock to get the current time.

```@docs; canonical=false
EnvironmentEngine.now
```

## Clock Types

### MachineClock - Real System Time

`MachineClock` uses your system's real time:

```@example clocks
using EnvironmentEngine

clock = MachineClock()

println(now(clock))  # Current system time, 0.0 seconds

resume!(clock)
sleep(1.0)
pause!(clock)

println(now(clock))  # Current system time, 1.0 seconds
```
When created, the `MachineClock` is paused by default, and can be resumed and paused at any time. 

```@docs; canonical=false
EnvironmentEngine.MachineClock
```

#### Stretch Factor
The `MachineClock` has a stretch factor, which is a factor by which the time is stretched. This is useful for building real-time applications, where the time is stretched to make the simulation run faster or slower than the real time. The stretch factor is set to 1.0 by default. If the stretch factor is greater than 1.0, the time will progress faster than the real time. For example, if the stretch factor is 2.0, the time will progress twice as fast as real time. You can set the stretch factor when creating the clock:

```@example clocks-machine-fast
using EnvironmentEngine

clock = MachineClock(stretch_factor = 2.0)
resume!(clock)
sleep(1.0)
pause!(clock)
println(now(clock))  # Current system time, 2.0 seconds
```

This is especially useful for debugging, and when you want to test if your agent has more/less computational resources available than on the machine you are running the simulation on.

**Use MachineClock when:**
- Building real-time applications
- You want to sync with wall clock time
- Running live simulations

### VirtualClock - Controllable Time

`VirtualClock` gives you complete control over time. In the `VirtualClock`, you can advance time completely seperate from wall clock time:

```@example clocks
clock = VirtualClock()

# Set initial time
set_time!(clock, 0.0s)

# Advance time manually
advance_time!(clock, 100ms)
println(now(clock))  # 0.1 s

advance_time!(clock, 50ms)
println(now(clock))  # 0.15 s
```

**Use VirtualClock when:**
- Building deterministic simulations
- You need reproducible results
- Debugging timing issues
- Testing with specific time scenarios

### Time Units

EnvironmentEngine uses Julia's `Unitful.jl` for time units:

```julia
# All of these are equivalent
every(100ms) do dt; end
every(0.1s) do dt; end
every(100e-3s) do dt; end
```

Common time units:
- `ms` - milliseconds
- `s` - seconds

## Integration with `for_next()`

In the previous tutorials, we used `for_next(duration)` to advance time. However, when we are using a custom clock, we have fine-grained control over time advancement. This is reflected with the `for_next(clock, duration)` function.

```julia
clock = VirtualClock()
for_next(clock, 100ms) do
    # Do your updates here
    advance_time!(clock, 10ms)
end
```
or:

```julia
clock = MachineClock()
for_next(clock, 100ms) do
    # Do your updates here
end
```
For `MachineClock`, `for_next` will automatically resume the clock and pause it after the duration has passed. By using a custom clock, you get control over the time advancement in your simulations.

## Next Steps

Now that you understand clocks and time control, explore:
- [Schedulers](@ref tutorial-schedulers) - Configure job execution behavior
- [Job Types](@ref tutorial-job-types) - Different ways to trigger jobs

