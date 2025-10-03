# [Sharp Bits](@id user-guide-sharp-bits)

This section covers some of the work in progress in `EnvironmentEngine`.

## Job timing

Let's look at the following pseudocode:

```julia
using EnvironmentEngine

clock = VirtualClock()
scheduler = TickedScheduler(clock, 1ms)


every(scheduler, 50ms) do dt
    plan!(agent)
end

every(scheduler, 5ms) do dt
    send_action!(agent, environment)
end

every(scheduler, 3ms) do dt
    update!(environment)
end

for_next(clock, 100ms) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
```

Let's see at what this code is executing, and then let's look at what we would want it to execute. At time 0ms, all 3 jobs are due and are scheduled. The scheduler will execute the jobs in the order they are scheduled, so the agent will start making a plan. This will take some time, and the next job is called which will send an action to the environment. However, the virtual time is still at 0ms, so, in a realistic environment, the plan that was just made by the agent would not have been available yet. The plan, in a sense, is fetched from the virtual future. Since we do not know (and can not know in advance) how long the planning would take, we have no way of knowing when the actual plan would have become available. 

## ASAP jobs and threading

Currently, when we are multithreading, the scheduler will wait until all jobs within a tick have been completed before advancing to the next tick. Let's look at the following code:

```julia
using EnvironmentEngine

clock = VirtualClock()
scheduler = TickedScheduler(clock, 1ms)

every(scheduler, asap) do
    plan!(agent)
end

every(scheduler, 10ms) do dt
    send_action!(agent, environment)
end

every(scheduler, 3ms) do dt
    update!(environment)
end

for_next(clock, 100ms) do
    update!(scheduler)
    advance_time!(clock, 10ms)
end
```

With this syntax, the user implies that `plan!` might take some time to complete, and we would just want to run it as soon as computational resources become available. However, with threading enabled, the scheduler will wait until all jobs within a tick have been completed before advancing to the next tick. This means that the `plan!` job will be executed at every tick, since the scheduler waits for the `plan!` job to complete before advancing to the next tick.

While this is a problem in threading, for single threaded execution, the problem is even worse. Since we only have 1 thread, all computational resources available will be dedicated to the `plan!` job, meaning that it will always have finished at the end of the tick, and will always be scheduled at the next tick.

We could solve this with a `blocking` keyword to the `every()` function, which would determine if the scheduler waits for a certain job to complete before advancing to the next tick. While this would solve the problem for multithreading, ensuring thread-safety would be a significant challenge, and still would not solve the problem for single threaded execution.