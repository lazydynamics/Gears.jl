@testitem "MachineClock constructor" begin
    import EnvironmentEngine: MachineClock, now, resume!
    using Unitful

    # Test default constructor
    clock = MachineClock()
    @test unit(clock.start_time) == u"s"
    @test clock.paused == true  # Clock starts paused
    @test clock.total_paused_time == 0u"s"

    # Resume the clock to start time progression
    resume!(clock)
    initial_time = now(clock)

    # The clock should start very close to 0 (allowing for small execution time)
    @test @inferred initial_time >= 0u"s"
    @test @inferred initial_time < 0.01u"s"  # Should be less than 10ms
end

@testitem "MachineClock time progression" begin
    import EnvironmentEngine: MachineClock, now, resume!
    using Unitful

    clock = MachineClock()
    resume!(clock)  # Start the clock

    # Test that time increases monotonically
    times = [now(clock) for _ in 1:5]
    for i in 2:length(times)
        @test times[i] >= times[i - 1]
    end

    # Test that sleep duration is reflected in time difference
    before = now(clock)
    sleep(0.1)
    after = now(clock)
    time_diff = after - before

    @test time_diff > 0u"s"
    @test time_diff >= 0.09u"s"  # Allow for some timing precision issues
    @test time_diff <= 0.2u"s"   # Should not be too much more than sleep time
end

@testitem "MachineClock pause and resume functionality" begin
    import EnvironmentEngine: MachineClock, now, pause!, resume!
    using Unitful

    clock = MachineClock()
    resume!(clock)  # Start the clock

    # Let some time pass
    sleep(0.1)
    time_before_pause = now(clock)
    pause!(clock)
    @test time_before_pause > 0u"s"
    @test clock.paused == true

    # Time should not progress while paused
    time_while_paused1 = now(clock)
    sleep(0.1)
    time_while_paused2 = now(clock)
    @test time_while_paused1 == time_while_paused2  # Time should be frozen

    # Resume the clock
    resume!(clock)
    time_after_resume = now(clock)
    @test clock.paused == false

    # Time should continue from where it was paused
    @test isapprox(time_after_resume, time_before_pause; atol = 10ms)  # Should be same as when paused

    # Let more time pass after resume
    sleep(0.1)
    time_after_sleep = now(clock)
    @test time_after_sleep > time_after_resume
end

@testitem "MachineClock multiple pause/resume cycles" begin
    import EnvironmentEngine: MachineClock, now, pause!, resume!
    using Unitful

    clock = MachineClock()
    resume!(clock)  # Start the clock

    # First pause/resume cycle
    sleep(0.05)
    time1 = now(clock)
    pause!(clock)
    sleep(0.1)  # This time should be "lost"
    resume!(clock)
    time2 = now(clock)
    @test isapprox(time2, time1; atol = 1ms)  # Should be same as before pause

    # Second pause/resume cycle
    sleep(0.05)
    time3 = now(clock)
    pause!(clock)
    sleep(0.1)  # This time should also be "lost"
    resume!(clock)
    time4 = now(clock)
    @test isapprox(time4, time3; atol = 3ms)  # Should be same as before second pause

    # Total logical time should be much less than real time
    @test time4 < 0.2u"s"  # Only ~0.1s of logical time passed
end

@testitem "MachineClock reset functionality" begin
    import EnvironmentEngine: MachineClock, now, pause!, resume!, reset!
    using Unitful

    clock = MachineClock()
    resume!(clock)  # Start the clock

    # Let time pass and pause
    sleep(0.1)
    pause!(clock)
    sleep(0.1)

    # Reset should clear everything
    reset!(clock)
    @test clock.paused == true  # Should be paused after reset
    @test clock.total_paused_time == 0u"s"

    # Resume and check time starts from 0
    resume!(clock)
    initial_time = now(clock)
    @test initial_time >= 0u"s"
    @test initial_time < 0.01u"s"
end

@testitem "MachineClock pause/resume edge cases" begin
    import EnvironmentEngine: MachineClock, now, pause!, resume!
    using Unitful

    clock = MachineClock()
    resume!(clock)  # Start the clock

    # Test calling pause! multiple times
    pause!(clock)
    time1 = now(clock)
    pause!(clock)  # Should be no-op
    time2 = now(clock)
    @test time1 == time2

    # Test calling resume! multiple times
    resume!(clock)
    time3 = now(clock)
    resume!(clock)  # Should be no-op
    time4 = now(clock)
    @test isapprox(time3, time4; atol = 3ms)
end
