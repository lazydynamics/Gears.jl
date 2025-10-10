
@testitem "TimedJob creation" setup = [MockSchedulers, MockClocks] begin
    import Gears: TimedJob, progress!, get_lag, get_period

    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)
    function f(dt)
        return dt
    end

    job = TimedJob(f, 1.0s)

    @test job.f == f
    @test get_period(job) == 1.0s
    @test get_lag(job) == 0.0s
end

@testitem "TimedJob time progression" setup = [MockSchedulers, MockClocks] begin
    import Gears: TimedJob, progress!, get_lag, get_period

    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)
    function f(dt)
        return dt
    end

    job = TimedJob(f, 1.0s)
    progress!(job, 0.5s)
    @test get_lag(job) == 0.5s
    progress!(job, 0.5s)
    @test get_lag(job) == 0s
end

@testitem "TimedJob execution" setup = [MockSchedulers, MockClocks] begin
    import Gears: TimedJob, progress!, get_lag, get_period

    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)
    collection = []
    function f(dt)
        push!(collection, dt)
    end

    job = TimedJob(f, 1.0s)
    @test isempty(collection)
    progress!(job, 0.5s)
    @test isempty(collection)
    progress!(job, 0.5s)
    @test length(collection) == 1
    @test first(collection) == 1.0s
    progress!(job, 0.5s)
    @test length(collection) == 1
    progress!(job, 10s)
    @test length(collection) == 11
    @test all(x -> x == 1.0s, collection)
end

@testitem "TimedJob scheduling" setup = [MockSchedulers, MockClocks] begin
    import Gears: schedule!, update!, advance_time!, TimedJob

    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    order = []
    function f1(dt)
        push!(order, 1)
    end

    function f2(dt)
        push!(order, 2)
    end

    job1 = TimedJob(f1, 1.0s)
    job2 = TimedJob(f2, 5.0s)

    schedule!(scheduler, job1)
    schedule!(scheduler, job2)

    advance_time!(clock, 2.0s)
    update!(scheduler)

    @test order == [1, 1]
    advance_time!(clock, 3.0s)
    update!(scheduler)
    @test order == [1, 1, 1, 1, 1, 2]

    advance_time!(clock, 3.0s)
    update!(scheduler)
    @test order == [1, 1, 1, 1, 1, 2, 1, 1, 1]
end
