@testmodule MockSchedulers begin
    using Unitful
    import Gears: Scheduler, Job, Clock, Ticker
    import Gears: schedule!, update!, progress!, now, advance_to!, can_tick, consume_tick!

    mutable struct MockScheduler <: Scheduler
        clock::Clock
        jobs::Vector{Job}
        ticker::Ticker
    end

    function schedule!(scheduler::MockScheduler, job::Job)
        push!(scheduler.jobs, job)
    end

    function update!(scheduler::MockScheduler)
        current_time = now(scheduler.clock)
        advance_to!(scheduler.ticker, current_time)

        while can_tick(scheduler.ticker)
            for job in scheduler.jobs
                progress!(job, scheduler.ticker.period)
            end
            consume_tick!(scheduler.ticker)
        end
    end

    function get_clock(scheduler::MockScheduler)
        return scheduler.clock
    end

    MockScheduler(clock) = MockScheduler(clock, [], Ticker(1.0u"μs"))
end
