# [Job Types](@id tutorial-job-types)

Jobs represent the actual work to be performed in `EnvironmentEngine`. They are the atomic building blocks created with the `every()` function. On this page we will cover the creation of different types of jobs.

## Job Types Overview

Currently, `EnvironmentEngine` supports the following job types:

1. **Timed Jobs** - Execute at regular intervals
2. **ASAP Jobs** - Execute as soon as possible (on every tick)
3. **Event Jobs** - Execute when data arrives on a channel

## Timed Jobs

Timed jobs execute at regular intervals. They're perfect for periodic tasks like sensor readings, data collection or environment updates.

### Basic Timed Jobs

```@example job_types
using EnvironmentEngine

clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms)

# Execute every 100 milliseconds
every(scheduler, 100ms) do dt
    println("Timed job executed")
end
```

Timed jobs require the `dt` parameter to be passed to the job body. This parameter represents the time interval between executions. It is also possible to pass a function to the `every()` function directly:

```@example job_types
function timed_job(dt)
    println("Timed job executed")
end

every(timed_job, scheduler, 100ms)
```

## ASAP Jobs

ASAP (As Soon As Possible) jobs run whenever the scheduler ticks. They're perfect for tasks that need to be executed as often as possible.

!!! note
    This behavior of `AsapJob` is different than desired. Ideally we would want an `AsapJob` to fire whenever it is not already running (e.g. start planning as soon as the previous planning is finished). This functionality is significantly more challenging, and more info can be found in the [Sharp Bits](@ref user-guide-sharp-bits) section.

ASAP jobs do not require any additional arguments to be passed to the job body, and can be created by passing the `asap` constant to the `every()` function.

```@example job_types
# Execute as soon as possible
every(scheduler, asap) do
    println("ASAP job executedj")
end
```

## Event Jobs

Event jobs execute when data arrives on a [Channel](https://docs.julialang.org/en/v1/manual/asynchronous-programming/). They're perfect for reactive programming and handling asynchronous events.

### Basic Event Jobs

```@example job_types
# Create a channel for events
events = Channel{String}(Inf)

clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms)

# Schedule job to run when events arrive
every(scheduler, events) do event
    println("Event processed at $(now(clock)): $event")
end

# Send some events
put!(events, "Hello")
put!(events, "World")
advance_time!(clock, 10ms)
update!(scheduler)
```

## Combining Job Types

You can mix different job types in the same application:

```@example job_types
using EnvironmentEngine

clock = VirtualClock()
scheduler = TickedScheduler(clock, 10ms)

# Create channels for different event types
sensor_data = Channel{Float64}(Inf)
alerts = Channel{String}(Inf)

# Timed job: Read sensor every 50ms
every(scheduler, 50ms) do dt
    reading = rand() * 100
    put!(sensor_data, reading)
end

# Event job: Process sensor data
every(scheduler, sensor_data) do data
    if data > 80
        put!(alerts, "High reading: $data")
    end
end

# Event job: Handle alerts
every(scheduler, alerts) do alert
    println("ALERT: $alert")
end

# ASAP job: Check for a condition
every(scheduler, asap) do
    if rand() < 0.1
        println("Low random number detected!")
    end
end

# Run the system
for_next(clock, 1s) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
```

## Common Pattern

### Producer-Consumer Pattern

```julia
# Producer: Generate data
every(50ms) do dt
    data = generate_data()
    put!(data_channel, data)
end

# Consumer: Process data
every(data_channel) do data
    process_data(data)
end
```

## Next Steps

Now that you understand the different job types, learn about:
- [Threading](@ref tutorial-threading) - Run jobs in parallel
