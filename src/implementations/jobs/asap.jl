import Base.Threads: Atomic, atomic_min!, atomic_max!

struct AsapJob{F} <: Job
    f::F
    is_processing::Atomic{Bool}
end

function progress!(job::AsapJob)
    # TODO: This is actually not thread safe because checking and flipping the flag are two seperate calls.
    if !job.is_processing[]
        atomic_max!(job.is_processing, true)
        job.f()
        atomic_min!(job.is_processing, false)
    end
end

AsapJob(f) = AsapJob(f, Atomic{Bool}(false))