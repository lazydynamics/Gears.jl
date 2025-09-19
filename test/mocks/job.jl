@testmodule MockJobs begin
    import EnvironmentEngine: Job, progress!
    using Unitful
    import Unitful: 𝐓
    using Base.Threads: Atomic
    import Base.Threads: atomic_add!

    struct MockJob <: Job
        f
    end

    function progress!(job::MockJob, dt::Quantity{<:Number, 𝐓})
        job.f()
    end

    struct CountingJob <: Job
        counter::Atomic{Int}
    end

    CountingJob() = CountingJob(Atomic{Int}(0))

    function progress!(job::CountingJob, dt::Quantity{<:Number, 𝐓})
        atomic_add!(job.counter, 1)
    end
end
