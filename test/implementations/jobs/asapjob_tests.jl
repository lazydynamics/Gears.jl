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
    progress!(job, 1ms)

    @test num_calls == 1
    progress!(job, 100s)

    @test num_calls == 2
end

@testitem "Test multithreaded" setup = [MockSchedulers, MockClocks] begin
    import EnvironmentEngine: AsapJob, progress!
    n_threads = Base.Threads.nthreads()
    if n_threads > 1
        counter = 0
        function f()
            sleep(0.1)
            global counter += 1
        end
        job = AsapJob(f)
        Threads.@threads for i in 1:n_threads
            progress!(job, 1ms)
        end
        @test counter == 1
    else
        has_multiple_threads = false
        @test_broken has_multiple_threads
    end
end
