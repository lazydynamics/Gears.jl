export every

function every(f, scheduler::Scheduler, period::Quantity{<:Number, 𝐓})
    period = convert(typeof(now(global_clock())), period)
    job = TimedJob(f, period)
    schedule!(scheduler, job)
    return job
end

function every(f, scheduler::Scheduler, channel::Channel)
    job = EventJob(f, channel)
    schedule!(scheduler, job)
    return job
end

function every(f, scheduler::Scheduler, asap::Asap)
    job = AsapJob(f)
    schedule!(scheduler, job)
    return job
end

every(f, smth) = every(f, global_scheduler(), smth)
