import Base.Threads: Atomic, atomic_xchg!, atomic_or!

struct AsapJob{F} <: Job
    f::F
    is_processing::Atomic{Bool}
end

function progress!(job::AsapJob, dt::Quantity{<:Number, 𝐓})
    if !atomic_or!(job.is_processing, true)
        job.f()
        atomic_xchg!(job.is_processing, false)
    end
end

AsapJob(f) = AsapJob(f, Atomic{Bool}(false))
