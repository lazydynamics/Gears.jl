@testitem "every with timed argument" setup = [MockSchedulers, MockClocks] begin
    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    set_global_clock!(clock)
    set_global_scheduler!(scheduler)

    fired = false
    every(1ms) do dt
        global fired = true
    end

    @test !fired

    EnvironmentEngine.advance_time!(clock, 1ms)
    update!(scheduler)

    @test fired
end

@testitem "every with channel argument" setup = [MockSchedulers, MockClocks] begin
    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    set_global_clock!(clock)
    set_global_scheduler!(scheduler)

    observations = Channel{Int}(10)

    fired = false
    every(observations) do observation
        global fired = true
    end

    put!(observations, 1)
    put!(observations, 2)

    @test !fired

    EnvironmentEngine.advance_time!(clock, 1ms)
    update!(scheduler)

    @test fired
    @test !isready(observations)

    observations = Channel{Int}(10)
    a = 1
    b = 2
    results = []
    every(observations) do observation
        push!(results, a + b)
    end

    @test results == []
    put!(observations, 1)

    EnvironmentEngine.advance_time!(clock, 1ms)
    update!(scheduler)

    @test results == [3]
end
