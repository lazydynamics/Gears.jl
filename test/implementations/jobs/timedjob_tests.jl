@testitem "TimedJob" setup = [MockSchedulers, MockClocks] begin
    using Unitful
    import EnvironmentEngine: TimedJob, progress!, get_lag, get_period

    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    @testset "TimedJob creation" begin
        function f(dt)
            return dt
        end

        job = TimedJob(f, 1.0u"s")

        @test job.f == f
        @test get_period(job) == 1.0u"s"
        @test get_lag(job) == 0.0u"s"
    end

    @testset "TimedJob time progression" begin
        function f(dt)
            return dt
        end

        job = TimedJob(f, 1.0u"s")
        progress!(job, 0.5u"s")
        @test get_lag(job) == 0.5u"s"
        progress!(job, 0.5u"s")
        @test get_lag(job) == 0u"s"
    end

    @testset "TimedJob execution" begin
        collection = []
        function f(dt)
            push!(collection, dt)
        end

        job = TimedJob(f, 1.0u"s")
        @test isempty(collection)
        progress!(job, 0.5u"s")
        @test isempty(collection)
        progress!(job, 0.5u"s")
        @test length(collection) == 1
        @test first(collection) == 1.0u"s"
        progress!(job, 0.5u"s")
        @test length(collection) == 1
        progress!(job, 10u"s")
        @test length(collection) == 11
        @test all(x -> x == 1.0u"s", collection)
    end

    @testset "TimedJob scheduling" begin
        import EnvironmentEngine: schedule!, update!, advance_time!

        order = []
        function f1(dt)
            push!(order, 1)
        end

        function f2(dt)
            push!(order, 2)
        end

        job1 = TimedJob(f1, 1.0u"s")
        job2 = TimedJob(f2, 5.0u"s")

        schedule!(scheduler, job1)
        schedule!(scheduler, job2)

        advance_time!(clock, 2.0u"s")
        update!(scheduler)

        @test order == [1, 1]
        advance_time!(clock, 3.0u"s")
        update!(scheduler)
        @test order == [1, 1, 1, 1, 1, 2]

        advance_time!(clock, 3.0u"s")
        update!(scheduler)
        @test order == [1, 1, 1, 1, 1, 2, 1, 1, 1]
    end
end