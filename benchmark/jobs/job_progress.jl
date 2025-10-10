using Gears
using BenchmarkTools

"""
Job execution performance benchmarks.
These measure the time to execute different job types.
"""

function benchmark_job_progress()
    suite = BenchmarkGroup()

    # Single job execution (with setup to isolate the operation)
    suite["timed_job_progress"] = @benchmarkable progress!(job, 10ms) setup = (job = TimedJob(x -> nothing, 10ms))

    suite["asap_job_progress"] = @benchmarkable progress!(job, 1ms) setup = (job = AsapJob(() -> nothing))

    suite["event_job_progress"] = @benchmarkable progress!(job, 1ms) setup =
        (channel = Channel{String}(Inf); job = EventJob(x -> nothing, channel); put!(channel, "test_event"))

    # Job execution with different periods
    for period in [1ms, 10ms, 100ms]
        suite["timed_job_$(period)_progress"] = @benchmarkable progress!(job, $period) setup = (
            job = TimedJob(x -> nothing, $period)
        )
    end

    # Job execution with actual work (not just nothing)
    suite["timed_job_with_work"] = @benchmarkable progress!(job, 10ms) setup = (job = TimedJob(x -> sum(1:100), 10ms))

    suite["asap_job_with_work"] = @benchmarkable progress!(job, 1ms) setup = (job = AsapJob(() -> sum(1:100)))

    return suite
end
