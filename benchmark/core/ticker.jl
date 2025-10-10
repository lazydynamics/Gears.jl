using Gears
using BenchmarkTools

"""
Core ticker performance benchmarks.
These measure the fundamental timing operations that drive the scheduler.
"""

function benchmark_ticker()
    suite = BenchmarkGroup()

    # Ticker creation overhead
    suite["ticker_creation"] = @benchmarkable Ticker(10ms)

    # Ticker operations (with setup to isolate the operation)
    suite["ticker_advance_to"] = @benchmarkable advance_to!(ticker, 5ms) setup = (ticker = Ticker(1.0ms))

    suite["ticker_progress"] = @benchmarkable progress!(ticker, 0.5ms) setup = (ticker = Ticker(1.0ms))

    suite["ticker_can_tick"] = @benchmarkable can_tick(ticker) setup = (
        ticker = Ticker(1.0ms); progress!(ticker, 1.5ms)
    )

    suite["ticker_consume_tick"] = @benchmarkable consume_tick!(ticker) setup = (
        ticker = Ticker(1.0ms); progress!(ticker, 1.5ms)
    )

    # Ticker reset performance
    suite["ticker_reset"] = @benchmarkable reset!(ticker, 10ms) setup = (ticker = Ticker(1ms))

    return suite
end
