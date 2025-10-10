using Gears
using BenchmarkTools

"""
Realistic usage pattern benchmarks.
These test common usage patterns from the documentation.
"""

function benchmark_realistic_scenarios()
    suite = BenchmarkGroup()

    # Basic every() + for_next() pattern
    suite["basic_pattern"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 1ms)

        # Schedule a job (simulating every(200ms))
        every(scheduler, 200ms) do dt
            sum(1:10)
        end

        # Simulate for_next(1000ms) pattern
        for _ in 1:1000
            advance_time!(clock, 1ms)
            update!(scheduler)
        end
    end

    # Mixed job types (from documentation example)
    suite["mixed_jobs_scenario"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 1ms)

        # Add different job types
        every(scheduler, 3ms) do dt
            sum(1:10)
        end
        every(scheduler, asap) do
            sum(1:10)
        end
        channel = Channel{String}(Inf)
        every(scheduler, channel) do observation
            sum(1:10)
        end

        # Simulate time progression with events
        for i in 1:20
            advance_time!(clock, 1ms)

            # Occasionally trigger events
            if i % 5 == 0
                put!(channel, "event_$i")
            end

            update!(scheduler)
        end
    end

    # Realistic simulation scenario
    suite["simulation_scenario"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 10ms)

        # Multiple timed jobs with different frequencies
        for period in [50ms, 100ms, 200ms, 500ms]
            every(scheduler, period) do dt
                sum(1:10)
            end
        end

        # Some ASAP jobs for immediate processing
        for i in 1:5
            every(scheduler, asap) do
                sum(1:5)
            end
        end

        # Event-driven jobs
        channel = Channel{String}(Inf)
        every(scheduler, channel) do observation
            sum(1:3)
        end

        # Simulate 1 second of simulation time
        for i in 1:100
            advance_time!(clock, 10ms)

            # Trigger events occasionally
            if i % 20 == 0
                put!(channel, "simulation_event_$i")
            end

            update!(scheduler)
        end
    end

    return suite
end
