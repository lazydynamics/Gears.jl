using EnvironmentEngine
using BenchmarkTools

"""
Clock performance benchmarks.
These measure the time access and manipulation operations.
"""

function benchmark_clocks()
    suite = BenchmarkGroup()

    # Clock creation
    suite["machine_clock_creation"] = @benchmarkable MachineClock()
    suite["virtual_clock_creation"] = @benchmarkable VirtualClock()

    # Clock operations (with setup to isolate the operation)
    suite["machine_clock_now"] = @benchmarkable now(clock) setup = (clock = MachineClock())

    suite["virtual_clock_now"] = @benchmarkable now(clock) setup = (clock = VirtualClock())

    suite["virtual_clock_set_time"] = @benchmarkable set_time!(clock, 5.0s) setup = (clock = VirtualClock())

    suite["virtual_clock_advance_time"] = @benchmarkable advance_time!(clock, 10ms) setup = (clock = VirtualClock())

    # Clock + ticker integration
    suite["clock_ticker_integration"] = @benchmarkable advance_to!(ticker, now(clock)) setup = (
        clock = VirtualClock(); ticker = Ticker(1ms)
    )

    return suite
end