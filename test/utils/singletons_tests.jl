@testitem "Global clock can be set and retrieved" begin
    import EnvironmentEngine: global_clock, set_global_clock!, Clock, MachineClock

    # Get the initial clock
    initial_clock = global_clock()
    @test typeof(initial_clock) <: Clock

    # Test setting custom clock
    custom_clock = MachineClock()
    set_global_clock!(custom_clock)
    @test global_clock() === custom_clock

    # Test setting back to initial
    set_global_clock!(initial_clock)
    @test global_clock() === initial_clock
end

@testitem "Global scheduler can be set and retrieved" begin
    using Unitful

    import EnvironmentEngine: global_scheduler, set_global_scheduler!, Scheduler, TickedScheduler, MachineClock

    # Get the initial scheduler
    initial_scheduler = global_scheduler()
    @test typeof(initial_scheduler) <: Scheduler

    # Test setting custom scheduler
    custom_scheduler = TickedScheduler(MachineClock(), 5.0u"s")
    set_global_scheduler!(custom_scheduler)
    @test global_scheduler() === custom_scheduler

    # Test setting back to initial
    set_global_scheduler!(initial_scheduler)
    @test global_scheduler() === initial_scheduler
end

@testitem "Global state persists across function calls" begin
    import EnvironmentEngine: global_clock, set_global_clock!

    # Get the initial clock
    initial_clock = global_clock()

    # Set a custom clock
    custom_clock = MachineClock()
    set_global_clock!(custom_clock)

    # Verify it persists
    @test global_clock() === custom_clock
    @test global_clock() === custom_clock  # Second call should return same instance

    # Clean up
    set_global_clock!(initial_clock)
end

@testitem "Setting different types works correctly" begin
    import EnvironmentEngine: global_clock, set_global_clock!, Clock, VirtualClock, MachineClock

    # Get the initial clock
    initial_clock = global_clock()
    initial_type = typeof(initial_clock)

    # Create a different clock type if possible
    if initial_type != typeof(MachineClock())
        different_clock = MachineClock()
    else
        different_clock = VirtualClock()
    end

    # Test setting different type
    set_global_clock!(different_clock)
    @test global_clock() === different_clock
    @test typeof(global_clock()) <: Clock

    # Clean up
    set_global_clock!(initial_clock)
end
