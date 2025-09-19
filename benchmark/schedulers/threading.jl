using EnvironmentEngine
using BenchmarkTools

"""
Threading performance comparison benchmarks.
These compare single-threaded vs multi-threaded scheduler performance.
"""

function benchmark_threading()
    suite = BenchmarkGroup()

    # Single-threaded scheduler performance
    suite["single_threaded"] = BenchmarkGroup()

    for job_count in [10, 100, 1000]
        suite["single_threaded"]["$(job_count)_jobs"] = @benchmarkable update!(scheduler) setup = (
            scheduler = begin
                clock = VirtualClock()
                scheduler = TickedScheduler(clock, 1ms; threading = false)

                # Add jobs
                for i in 1:($job_count)
                    job = TimedJob(x -> sum(1:10), 10ms)  # Some actual work
                    schedule!(scheduler, job)
                end

                advance_time!(clock, 10ms)
                scheduler
            end
        )
    end

    # Multi-threaded scheduler performance
    suite["multi_threaded"] = BenchmarkGroup()

    for job_count in [10, 100, 1000]
        suite["multi_threaded"]["$(job_count)_jobs"] = @benchmarkable update!(scheduler) setup = (
            scheduler = begin
                clock = VirtualClock()
                scheduler = TickedScheduler(clock, 1ms; threading = true)

                # Add jobs
                for j in 1:($job_count)
                    job = TimedJob(x -> sum(1:10), 10ms)  # Some actual work
                    schedule!(scheduler, job)
                end

                advance_time!(clock, 100ms)
                scheduler
            end
        )
    end

    # Threading overhead comparison
    suite["threading_overhead"] = @benchmarkable update!(scheduler) setup = begin
        clock = VirtualClock()
        scheduler = TickedScheduler(clock, 1ms; threading = true)

        # Add a single job to measure pure threading overhead
        job = TimedJob(x -> nothing, 10ms)
        schedule!(scheduler, job)

        advance_time!(clock, 10ms)
    end

    return suite
end