using Unitful

abstract type Scheduler end

"""
    schedule!(scheduler::Scheduler, task::ScheduledTask)

Register a task with the scheduler to run at the specified period.
"""
function schedule!(scheduler::Scheduler, task::ScheduledTask)
    throw(NotImplementedError("`schedule!` is not implemented for $(typeof(scheduler))"))
end

"""
    run!(scheduler::Scheduler, t)

Run the scheduler for `t` seconds.
"""
function run!(scheduler::Scheduler, t)
    throw(NotImplementedError("`run!` is not implemented for $(typeof(scheduler))"))
end

"""
    cycle!(scheduler)

Execute one cycle of the scheduler, distributing time to all registered tasks.
"""
function cycle!(scheduler::Scheduler)
    throw(NotImplementedError("`cycle!` is not implemented for $(typeof(scheduler))"))
end

"""
    get_clock(scheduler::Scheduler)

Get the clock associated with the scheduler.
"""
function get_clock(scheduler::Scheduler)
    throw(NotImplementedError("`get_clock` is not implemented for $(typeof(scheduler))"))
end