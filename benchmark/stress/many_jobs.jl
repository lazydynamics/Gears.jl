using EnvironmentEngine
using BenchmarkTools

"""
Many jobs stress test benchmarks.
These test the system with large numbers of jobs.
"""

function benchmark_many_jobs()
    suite = BenchmarkGroup()

    # Many jobs, single update
    for job_count in [1000, 5000, 10000]
        suite["$(job_count)_jobs_single_update"] = @benchmarkable begin
            clock = VirtualClock()
            scheduler = TickedScheduler(clock, 1ms)

            # Add many jobs
            for i in 1:($job_count)
                every(scheduler, 10ms) do dt
                    sum(1:10)
                end
            end

            advance_time!(clock, 10ms)
            update!(scheduler)
        end
    end

    # Many jobs with different periods
    suite["many_jobs_mixed_periods"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 1ms)

        periods = [1ms, 5ms, 10ms, 50ms, 100ms]

        # Add jobs with different periods
        for i in 1:1000
            period = periods[mod1(i, length(periods))]
            every(scheduler, period) do dt
                sum(1:10)
            end
        end

        advance_time!(clock, 100ms)
        update!(scheduler)
    end

    # Many ASAP jobs (stress test atomic operations)
    suite["many_asap_jobs"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 1ms)

        # Add many ASAP jobs
        for i in 1:1000
            every(scheduler, asap) do
                sum(1:10)
            end
        end

        advance_time!(clock, 10ms)
        update!(scheduler)
    end

    # Memory allocation stress test
    suite["memory_allocation_stress"] = @benchmarkable begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 1ms)

        # Jobs that allocate memory
        for i in 1:100
            every(scheduler, 1ms) do dt
                rand(100)
            end
        end

        advance_time!(clock, 10ms)
        update!(scheduler)
    end

    return suite
end