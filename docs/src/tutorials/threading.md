# [Threading](@id tutorial-threading)

Learn how to run jobs in parallel using Gears's threading capabilities. This tutorial covers when and how to use multi-threading effectively.

## Threading Overview

Gears supports running jobs in multiple threads, allowing you to:
- Execute multiple jobs simultaneously
- Improve performance for CPU-intensive tasks
- Handle concurrent operations efficiently

## Enabling Threading

Threading is enabled by passing the `threading=true` keyword argument to the `TickedScheduler` constructor.

### Basic Threading Setup

```@example threading
using Gears

clock = VirtualClock()

# Enable threading in the scheduler
scheduler = TickedScheduler(clock, 10ms; threading=true)

# Schedule jobs - they can now run in parallel
every(scheduler, 50ms) do dt
    println("Job 1 at $(now(clock))")
end

every(scheduler, 50ms) do dt
    println("Job 2 at $(now(clock))")
end

# Run the threaded scheduler
for_next(clock, 200ms) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
```

## Threading Behavior

### Job Execution Model

With threading enabled:
- Jobs scheduled for the same tick can run in parallel
- All jobs for a tick must complete before the next tick starts
- This prevents race conditions between ticks

```@example threading
scheduler = TickedScheduler(clock, 10ms; threading=true)

# These jobs can run in parallel within the same tick
every(scheduler, 20ms) do dt
    println("Job A at $(now(clock))")
    sleep(0.005)  # Simulate work
end

every(scheduler, 20ms) do dt
    println("Job B at $(now(clock))")
    sleep(0.005)  # Simulate work
end
```

## Thread Safety

Thread safety is a highly complex topic, hence we will repeat the same warning as is in the [Julia documentation](https://docs.julialang.org/en/v1/manual/multi-threading/#Data-race-freedom):

!!! danger "Data Race Safety is Your Responsibility"
    You are entirely responsible for ensuring that your program is data-race free, and nothing promised here can be assumed if you do not observe that requirement. The observed results may be highly unintuitive.

    If data-races are introduced, Julia is not memory safe. Be very careful about reading any data if another thread might write to it, as it could result in segmentation faults or worse.

When accessing a mutable state from multiple jobs, it is the user's responsibility to ensure that the state is thread-safe and ensure and appropriate locking mechanism is used.


### Unsafe Patterns

**Shared mutable state:**
```@example threading
clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms; threading=true)

# Unsafe: Multiple threads modifying shared state
shared_counter = Ref(0)
second_shared_counter = Ref(0)

every(scheduler, 10ms) do dt
    shared_counter[] += 1  # First access to mutable state
end

every(scheduler, 10ms) do dt
    second_shared_counter[] += shared_counter[]  # Race condition! Second access to mutable state
end

for_next(clock, 100ms) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
println("shared_counter: $(shared_counter[])")
println("second_shared_counter: $(second_shared_counter[])")
```

### Safe Patterns

**Obtain lock before accessing shared state:**
```@example threading
clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms; threading=true)
lck = ReentrantLock()


# Unsafe: Multiple threads modifying shared state
shared_counter = Ref(0)
second_shared_counter = Ref(0)

every(scheduler, 10ms) do dt
    lock(lck) do
        shared_counter[] += 1  # First access to mutable state
    end
end

every(scheduler, 10ms) do dt
    lock(lck) do
        second_shared_counter[] += shared_counter[]  # Race condition! Second access to mutable state
    end
end

for_next(clock, 100ms) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
println("shared_counter: $(shared_counter[])")
println("second_shared_counter: $(second_shared_counter[])")
```

**Read-only access:**
```julia
scheduler = TickedScheduler(clock, 10ms; threading=true)

# Safe: Multiple threads can read the same data
every(scheduler, 50ms) do dt
    value = read_configuration()
    use_value(value)
end
```

## Performance Considerations

### Threading Overhead

Threading has overhead, so it's only beneficial when:
- Jobs are CPU-intensive
- Multiple jobs run simultaneously
- The work outweighs the threading overhead

## Next Steps

Congratulations! You have completed the tutorial series for `Gears`. In order to get more information, you can:
- [API Reference](@ref user-guide-api-reference) - Complete function and type documentation
- [Sharp Bits](@ref user-guide-sharp-bits) - Learn about sharp bits
