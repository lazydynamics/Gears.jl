using EnvironmentEngine
using BenchmarkTools

"""
High-frequency stress test benchmarks.
These test the system under rapid scheduling and execution.
"""

function benchmark_high_frequency()
    suite = BenchmarkGroup()

    # Rapid scheduler updates
    suite["rapid_updates"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 0.1ms)  # Very fast tick rate

        # Add some jobs
        for i in 1:10
            every(scheduler, 1.0ms) do dt
                sum(1:10)
            end
        end

        # Rapid updates
        for _ in 1:100
            advance_time!(clock, 0.1ms)
            update!(scheduler)
        end
    end

    # High-frequency job creation and execution
    suite["rapid_job_creation"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 0.1ms)

        # Create and schedule jobs rapidly
        for i in 1:100
            every(scheduler, 1.0ms) do dt
                sum(1:10)
            end
            advance_time!(clock, 0.1ms)
            update!(scheduler)
        end
    end

    # Mixed high-frequency operations
    suite["mixed_rapid_operations"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 0.1ms)

        # Mix of job types
        for i in 1:50
            # Add timed job
            every(scheduler, 1.0ms) do dt
                sum(1:10)
            end

            # Add ASAP job
            every(scheduler, asap) do
                sum(1:10)
            end

            advance_time!(clock, 0.1ms)
            update!(scheduler)
        end
    end

    return suite
end