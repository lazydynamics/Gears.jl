@testmodule MockJobs begin
    struct MockJob <: Job
        f
    end

    function execute(job::MockJob, dt::Quantity{<:Number, 𝐓})
        job.f()
    end
end