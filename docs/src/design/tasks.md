# Job System Design

## Job Interface

All jobs implement a common interface regardless of their trigger mechanism:

```julia
abstract type Job end

function execute(job::Job, dt::Quantity{<:Number, 𝐓})
    # Must be implemented by concrete job types
end
```

## Job Types

### TimedJob
Jobs that execute at regular time intervals.

**Behavior:**
- Maintains internal time accumulator
- Receives time delta from scheduler on each execution cycle
- Executes when accumulator reaches execution period threshold (lag >= period)
- Resets accumulator after execution (lag -= period)

**Example:**
```julia
every(2ms) do dt
    act!(agent, env)
end
```

### EventJob
Jobs that execute when specific conditions are met.

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

## Job Creation

The `every` function provides a unified interface for creating both job types:

- **Time-based**: `every(time_period) do dt ... end`
- **Event-based**: `every(observable_object) do obj ... end`

Julia's multiple dispatch automatically routes to the appropriate job constructor based on the first argument type.

## Job State Management

Jobs are stateless in terms of execution logic but may maintain:
- Timing accumulators (TimedJob)
- State hashes (EventJob)
- Execution periods
- Enabled/disabled state

## Job Execution Model

1. **Registration**: Job registers with global scheduler
2. **Execution Cycle**: Scheduler calls `execute(dt)` on all registered jobs
3. **Self-Determination**: Each job decides whether to perform work based on its internal logic
4. **State Update**: Job updates internal state after execution
