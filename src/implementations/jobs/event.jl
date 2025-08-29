struct EventJob{F, T} <: Job
    f::F
    channel::T
end

function progress!(job::EventJob, dt::Quantity{<:Number, 𝐓})
    while isready(job.channel)
        job.f(take!(job.channel))
    end
end