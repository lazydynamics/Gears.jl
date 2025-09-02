import Base.Threads: Atomic, atomic_xchg!, atomic_or!

struct AsapJob{F} <: Job
    f::F
    is_processing::Atomic{Bool}
end

function progress!(job::AsapJob)
    # TODO: This is actually not thread safe because checking and flipping the flag are two seperate calls.
    if !atomic_or!(job.is_processing, true)
        job.f()
        atomic_xchg!(job.is_processing, false)
    end
end

AsapJob(f) = AsapJob(f, Atomic{Bool}(false))