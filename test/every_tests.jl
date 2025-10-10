@testitem "every with timed argument" setup = [MockSchedulers, MockClocks] begin
    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    fired = false
    every(scheduler, 1ms) do dt
        global fired = true
    end

    @test !fired

    Gears.advance_time!(clock, 1ms)
    update!(scheduler)

    @test fired
end

@testitem "every with channel argument" setup = [MockSchedulers, MockClocks] begin
    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    observations = Channel{Int}(10)

    fired = false
    every(scheduler, observations) do observation
        global fired = true
    end

    put!(observations, 1)
    put!(observations, 2)

    @test !fired

    Gears.advance_time!(clock, 1ms)
    update!(scheduler)

    @test fired
    @test !isready(observations)

    observations = Channel{Int}(10)
    a = 1
    b = 2
    results = []
    every(scheduler, observations) do observation
        push!(results, a + b)
    end

    @test results == []
    put!(observations, 1)

    Gears.advance_time!(clock, 1ms)
    update!(scheduler)

    @test results == [3]
end

@testitem "every with asap argument" setup = [MockSchedulers, MockClocks] begin
    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    fired = false
    every(scheduler, asap) do
        global fired = true
    end

    @test !fired
    Gears.advance_time!(clock, 1ms)
    update!(scheduler)
    @test fired
end
