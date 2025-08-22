# API Design

## Overview

The EnvironmentEngine provides a high-level API centered around the `every` function, which creates and schedules tasks through multiple dispatch based on the input type. This design enables intuitive task creation while maintaining the underlying architectural separation.

## Core API

### Task Creation

#### Time-Based Tasks
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

#### Event-Based Tasks
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

The `every` function automatically creates the appropriate task type:

- **`every(time_period)`** → Creates `TimedTask`
- **`every(observable_object)`** → Creates `EventTask`

Julia's type system routes to the correct constructor based on the first argument.

## Global Scheduler

The system provides a global scheduler instance for convenience:

```julia
# Package automatically creates default scheduler with default clock
# Tasks created with every() are automatically registered

# Can configure or replace the global scheduler
set_global_scheduler!(custom_scheduler)
set_global_clock!(VirtualClock())
```

## Task Control

### Enable/Disable
```julia
# Disable a specific task
disable_task!(task_handle)

# Re-enable a task
enable_task!(task_handle)
```

### Task Removal
```julia
# Remove a task from the system
remove_task!(task_handle)
```

## Clock Control

### Virtual Clock Operations
```julia
# Advance time by 1ms
advance_time!(1ms)

# Set time to specific value
set_time!(5.0s)

# Reset to zero
reset_time!()
```

## Configuration

### Scheduler Settings
```julia
# Configure execution frequency
set_scheduler_frequency!(1000Hz)

# Set time step for virtual clock
set_time_step!(1ms)
```

### Clock Selection
```julia
# Switch to virtual clock for simulation
use_virtual_clock!()

# Switch back to real-time clock
use_machine_clock!()
```
