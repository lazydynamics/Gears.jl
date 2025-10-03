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

Update the scheduler to the current time as provided with the associated clock. This distributes time to the scheduled jobs until virtual time has caught up with the current time provided by the clock (optionally also virtual).
"""
function update!(scheduler::Scheduler)
    throw(NotImplementedError("`update!` is not implemented for $(typeof(scheduler))"))
end

update!() = update!(global_scheduler())
