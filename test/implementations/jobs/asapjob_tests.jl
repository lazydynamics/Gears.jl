@testitem "AsapJob creation" begin
    import EnvironmentEngine: AsapJob

    function f() end

    job = AsapJob(f)

    @test job.f == f
end

@testitem "AsapJob execution" begin
    import EnvironmentEngine: AsapJob, progress!

    num_calls = 0
    function f()
        global num_calls += 1
    end

    job = AsapJob(f)
    progress!(job)

    @test num_calls == 1
    progress!(job)

    @test num_calls == 2
end
