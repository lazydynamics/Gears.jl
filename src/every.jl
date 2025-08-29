function every(f, period::Quantity{<:Number, 𝐓})
    period = convert(typeof(now(global_clock())), period)
    job = TimedJob(f, period)
    schedule!(global_scheduler(), job)
    return job
end

function every(f, channel::Channel)
    job = EventJob(f, channel)
    schedule!(global_scheduler(), job)
    return job
end