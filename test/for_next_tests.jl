@testitem "basic for_next functionality" setup = [MockClocks, MockSchedulers] begin
    import EnvironmentEngine: advance_time!
    clock = MockClocks.MockClock()

    # Test explicit clock usage
    call_count = 0
    for_next(clock, 5ms) do
        global call_count += 1
        advance_time!(clock, 1ms)
    end
    @test call_count > 0

    # Test global clock convenience method
    call_count_global = 0
    for_next(1ms) do
        global call_count_global += 1
    end
    @test call_count_global > 0

    # Test zero duration (should not call function)
    call_count_zero = 0
    for_next(clock, 0ms) do
        global call_count_zero += 1
    end
    @test call_count_zero == 0

    # Test thrown error
    clock = MockClocks.MockClock()
    @test_throws ErrorException for_next(clock, 1ms) do
        nothing
    end
end

@testitem "for_next timing and duration" setup = [MockClocks, MockSchedulers] begin
    import EnvironmentEngine: advance_time!
    clock = MockClocks.MockClock()

    # Test duration accuracy
    start_time = now(clock)
    call_count = 0
    for_next(clock, 10ms) do
        global call_count += 1
        advance_time!(clock, 1ms)
    end
    end_time = now(clock)
    duration = end_time - start_time
    @test duration ≈ 10ms
    @test call_count > 0
end

@testitem "for_next state management and time progression" setup = [MockClocks, MockSchedulers] begin
    clock = MockClocks.MockClock()

    # Test function can modify external state
    results = []
    for_next(clock, 5ms) do
        push!(results, now(clock))
        advance_time!(clock, 1ms)
    end
    @test length(results) > 0
    @test all(t -> t >= 0s, results)
end

@testitem "for_next integration and error handling" setup = [MockClocks, MockSchedulers] begin
    import EnvironmentEngine: advance_time!
    clock = MockClocks.MockClock()
    scheduler = MockSchedulers.MockScheduler(clock)

    # Test integration with scheduler
    task_executed = false
    every(scheduler, 1ms) do dt
        global task_executed = true
    end

    # Use for_next to run the scheduler for 5ms
    for_next(clock, 5ms) do
        update!(scheduler)
        advance_time!(clock, 1ms)
    end
    @test task_executed
end
