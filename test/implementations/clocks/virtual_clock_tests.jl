@testitem "VirtualClock" begin
    import Gears: VirtualClock, now, set_time!, advance_time!
    using Unitful

    clock = VirtualClock()

    @test now(clock) == 0.0u"s"

    advance_time!(clock, 1.0u"s")
    @test now(clock) == 1.0u"s"

    advance_time!(clock, 1.0u"s")
    @test now(clock) == 2.0u"s"

    set_time!(clock, 0.0u"s")
    @test now(clock) == 0.0u"s"
end
