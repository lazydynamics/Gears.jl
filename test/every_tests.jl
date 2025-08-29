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