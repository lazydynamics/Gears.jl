using Gears
using BenchmarkTools

"""
Job creation and management benchmarks.
These measure the overhead of creating and scheduling different job types.
"""

function benchmark_job_creation()
    suite = BenchmarkGroup()

    # Job creation overhead
    suite["timed_job_creation"] = @benchmarkable TimedJob(x -> nothing, 10ms)
    suite["asap_job_creation"] = @benchmarkable AsapJob(() -> nothing)
    suite["event_job_creation"] = @benchmarkable begin
        channel = Channel{String}(Inf)
        EventJob(x -> nothing, channel)
    end

    # Job creation with different periods
    for period in [1ms, 10ms, 100ms, 1000ms]
        suite["timed_job_$(period)_creation"] = @benchmarkable TimedJob(x -> nothing, $period)
    end

    # Job scheduling overhead (with setup to isolate the operation)
    suite["schedule_timed_job"] = @benchmarkable schedule!(scheduler, job) setup =
        (clock = VirtualClock(); scheduler = TickedScheduler(clock, 1ms); job = TimedJob(x -> nothing, 10ms))

    suite["schedule_asap_job"] = @benchmarkable schedule!(scheduler, job) setup =
        (clock = VirtualClock(); scheduler = TickedScheduler(clock, 1ms); job = AsapJob(() -> nothing))

    suite["schedule_event_job"] = @benchmarkable schedule!(scheduler, job) setup = (
        clock = VirtualClock();
        scheduler = TickedScheduler(clock, 1ms);
        channel = Channel{String}(Inf);
        job = EventJob(x -> nothing, channel)
    )

    return suite
end
