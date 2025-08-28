@testmodule MockClocks begin
    using Unitful
    import EnvironmentEngine: Clock, now, set_time!, advance_time!

    mutable struct MockClock <: Clock
        current_time
    end

    function now(clock::MockClock)
        return clock.current_time
    end

    function set_time!(clock::MockClock, time)
        clock.current_time = time
    end

    function advance_time!(clock::MockClock, dt)
        clock.current_time += dt
    end

    MockClock() = MockClock(0.0u"s")
end