using Unitful

export schedule!, update!

abstract type Scheduler end

"""
    schedule!(scheduler::Scheduler, job::Job)

Register a job with the scheduler to run. Can be implemented for concrete types to define scheduling behavior for different schedulers and job types.
"""
function schedule!(scheduler::Scheduler, job::Job)
    throw(NotImplementedError("`schedule!` is not implemented for $(typeof(scheduler))"))
end

"""
    update!(scheduler::Scheduler)

Update the scheduler.
"""
function update!(scheduler::Scheduler)
    throw(NotImplementedError("`update!` is not implemented for $(typeof(scheduler))"))
end

update!() = update!(global_scheduler())