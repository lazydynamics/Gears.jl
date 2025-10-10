using Gears
using BenchmarkTools

"""
TickedScheduler performance benchmarks.
These measure the core scheduler operations, especially update! performance.
"""

function benchmark_ticked_scheduler()
    suite = BenchmarkGroup()

    # Empty scheduler operations (baseline)
    suite["update_empty"] = @benchmarkable update!(scheduler) setup =
        (clock = VirtualClock(); scheduler = TickedScheduler(clock, 1ms))

    # Scheduler update with varying job counts
    for job_count in [1, 10, 100, 1000]
        suite["update_$(job_count)_jobs"] = @benchmarkable update!(scheduler) setup = (
            scheduler = begin
                clock = VirtualClock()
                scheduler = TickedScheduler(clock, 1ms)

                # Add jobs
                for i in 1:($job_count)
                    job = TimedJob(x -> nothing, 10ms)
                    schedule!(scheduler, job)
                end

                # Advance time to trigger job execution
                advance_time!(clock, 10ms)
                scheduler
            end
        )
    end

    # Scheduler update with different tick frequencies
    for tick_freq in [0.1ms, 1ms, 10ms, 100ms]
        suite["update_$(tick_freq)_tick_freq"] = @benchmarkable update!(scheduler) setup = (
            scheduler = begin
                clock = VirtualClock()
                scheduler = TickedScheduler(clock, $tick_freq)

                # Add some jobs
                for i in 1:10
                    job = TimedJob(x -> nothing, 10.0ms)
                    schedule!(scheduler, job)
                end

                advance_time!(clock, 10.0ms)
                scheduler
            end
        )
    end

    # Scheduler creation overhead
    suite["scheduler_creation"] = @benchmarkable TickedScheduler(clock, 1.0ms) setup = (clock = VirtualClock())

    # Scheduler creation with threading
    suite["scheduler_creation_threaded"] = @benchmarkable TickedScheduler(clock, 1.0ms; threading = true) setup = (
        clock = VirtualClock()
    )

    return suite
end
