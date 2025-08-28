@testitem "Ticker" begin
    import EnvironmentEngine: Ticker, advance_to!, progress!, can_tick, consume_tick!
    using Unitful

    ticker = Ticker(1.0u"s")

    @test ticker.period == 1.0u"s"
    @test ticker.last_tick_time == 0.0u"s"
    @test ticker.accumulated_lag == 0.0u"s"

    advance_to!(ticker, 1.0u"s")
    @test ticker.last_tick_time == 0.0u"s"
    @test ticker.accumulated_lag == 1.0u"s"

    @test can_tick(ticker) == true
    consume_tick!(ticker)
    @test can_tick(ticker) == false
    @test ticker.last_tick_time == 1.0u"s"
    @test ticker.accumulated_lag == 0.0u"s"

    advance_to!(ticker, 2.0u"s")
    @test can_tick(ticker) == true
    consume_tick!(ticker)
    @test can_tick(ticker) == false
    @test ticker.accumulated_lag == 0.0u"s"
end