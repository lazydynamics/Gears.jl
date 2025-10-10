
@testitem "EventJob creation" begin
    import Gears: EventJob

    queue = Channel(1)
    function f(object)
        return object
    end

    job = EventJob(f, queue)

    @test job.f == f
    @test !isready(job.channel)
end

@testitem "EventJob execution" begin
    import Gears: EventJob, progress!

    queue = Channel(1)
    collection = []
    function f(object)
        push!(collection, object)
    end

    job = EventJob(f, queue)
    progress!(job, 1s)
    @test isempty(collection)
    put!(queue, 1)
    @test isempty(collection)
    progress!(job, 1s)
    @test length(collection) == 1
    @test first(collection) == 1
    put!(queue, 2)
    @test length(collection) == 1
    progress!(job, 1s)
    @test length(collection) == 2
end

@testitem "EventJob buffered elements" begin
    import Gears: EventJob, progress!

    c1 = Channel(10)

    collection = []
    function f(object)
        push!(collection, object)
    end

    job = EventJob(f, c1)
    put!(c1, 1)
    put!(c1, 2)
    put!(c1, 3)
    progress!(job, 1s)
    @test length(collection) == 3
    @test collection == [1, 2, 3]
end

@testitem "EventJob scheduling" setup = [MockSchedulers, MockClocks] begin
    import Gears: schedule!, update!, advance_time!, EventJob

    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    order = []
    c1 = Channel(1)
    c2 = Channel(1)
    function f1(dt)
        push!(order, 1)
    end

    function f2(dt)
        push!(order, 2)
    end

    job1 = EventJob(f1, c1)
    job2 = EventJob(f2, c2)

    schedule!(scheduler, job1)
    schedule!(scheduler, job2)

    advance_time!(clock, 1ms)
    update!(scheduler)

    @test order == []
    put!(c1, 1)

    advance_time!(clock, 1ms)
    update!(scheduler)

    @test order == [1]
    put!(c2, 1)

    advance_time!(clock, 1ms)
    update!(scheduler)

    @test order == [1, 2]
    put!(c1, 1)
    put!(c2, 1)

    advance_time!(clock, 1ms)
    update!(scheduler)

    @test order == [1, 2, 1, 2]
end
