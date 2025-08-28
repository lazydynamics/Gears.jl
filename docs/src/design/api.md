# API Design

## Overview

The EnvironmentEngine provides a high-level API centered around the `every` function, which creates and schedules jobs through multiple dispatch based on the input type. This design enables intuitive job creation while maintaining the underlying architectural separation.

## Core API

### Job Creation

#### Time-Based Jobs
```julia
# Execute every 2 milliseconds
every(2ms) do dt
    act!(agent, env)
end

# Execute every 100 microseconds
every(100μs) do dt
    update_sensors!()
end
```

#### Event-Based Jobs
```julia
# Execute when observation cache changes
every(obs_cache) do obs
    state_update!(agent, obs)
end

# Execute when action cache updates
every(action_cache) do action
    execute_action!(robot, action)
end
```

## Multiple Dispatch

The `every` function automatically creates the appropriate job type:

- **`every(time_period)`** → Creates `TimedJob`
- **`every(observable_object)`** → Creates `EventJob`

Julia's type system routes to the correct constructor based on the first argument.

## Global Scheduler

The system provides a global scheduler instance for convenience:

```julia
# Package automatically creates default scheduler with default clock
# Jobs created with every() are automatically registered

# Can configure or replace the global scheduler
set_global_scheduler!(custom_scheduler)
set_global_clock!(VirtualClock())
```
