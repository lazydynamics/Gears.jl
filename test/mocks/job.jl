@testmodule MockJobs begin
    import EnvironmentEngine: Job, progress!
    using Unitful
    import Unitful: 𝐓
    struct MockJob <: Job
        f
    end

    function progress!(job::MockJob, dt::Quantity{<:Number, 𝐓})
        job.f()
    end
end