@testitem "MachineClock" begin
    import EnvironmentEngine: MachineClock, now
    using Unitful

    clock = MachineClock()

    @test now(clock) > 0u"s"
end