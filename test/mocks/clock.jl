@testmodule MockClocks begin
    struct MockClock <: Clock
        current_time::Quantity{Int64, 𝐓, Unitful.FreeUnits{(s,), 𝐓, nothing}}
    end

    function now(clock::MockClock)
        return clock.current_time
    end

    function set_time!(clock::MockClock, time::Quantity{Int64, 𝐓, Unitful.FreeUnits{(s,), 𝐓, nothing}})
        clock.current_time = time
    end
end