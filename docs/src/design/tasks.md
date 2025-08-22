# Task System Design

## Task Interface

All tasks implement a common interface regardless of their trigger mechanism:

```julia
abstract type Task end

function execute(task::Task, dt::Quantity{<:Number, 𝐓})
    # Must be implemented by concrete task types
end
```

## Task Types

### TimedTask
Tasks that execute at regular time intervals.

**Behavior:**
- Maintains internal time accumulator
- Receives time delta from scheduler on each execution cycle
- Executes when accumulator reaches execution period threshold
- Resets accumulator after execution

**Example:**
```julia
every(2ms) do dt
    act!(agent, env)
end
```

### EventTask
Tasks that execute when specific conditions are met.

**Behavior:**
- Stores hash of observed object state
- Compares current hash with stored hash on each execution cycle
- Executes when hash changes (indicating state change)
- Updates stored hash after execution

**Example:**
```julia
every(obs_cache) do obs
    state_update!(agent, obs)
end
```

## Task Creation

The `every` function provides a unified interface for creating both task types:

- **Time-based**: `every(time_period) do dt ... end`
- **Event-based**: `every(observable_object) do obj ... end`

Julia's multiple dispatch automatically routes to the appropriate task constructor based on the first argument type.

## Task State Management

Tasks are stateless in terms of execution logic but may maintain:
- Timing accumulators (TimedTask)
- State hashes (EventTask)
- Execution periods
- Enabled/disabled state

## Task Execution Model

1. **Registration**: Task registers with global scheduler
2. **Execution Cycle**: Scheduler calls `execute(dt)` on all registered tasks
3. **Self-Determination**: Each task decides whether to perform work based on its internal logic
4. **State Update**: Task updates internal state after execution
