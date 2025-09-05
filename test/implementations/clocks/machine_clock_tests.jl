@testitem "MachineClock constructor" begin
    import EnvironmentEngine: MachineClock, now
    using Unitful

    # Test default constructor
    clock = MachineClock()
    @test unit(clock.start_time) == u"s"

    clock = MachineClock()
    initial_time = now(clock)

    # The clock should start very close to 0 (allowing for small execution time)
    @test @inferred initial_time >= 0u"s"
    @test @inferred initial_time < 0.01u"s"  # Should be less than 10ms
end

@testitem "MachineClock time progression" begin
    import EnvironmentEngine: MachineClock, now
    using Unitful

    clock = MachineClock()

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
