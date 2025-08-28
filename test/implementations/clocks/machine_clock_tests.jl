@testitem "MachineClock" begin
    import EnvironmentEngine: MachineClock, now
    using Unitful

    clock = MachineClock()

    @test now(clock) > 0u"s"
    before = now(clock)
    sleep(0.1)
    after = now(clock)
    @test after > before
end