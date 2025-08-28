using Unitful

"""
    TickedScheduler{C <: Clock, T} <: Scheduler

A scheduler that processes jobs at regular tick intervals.

# Fields
- `clock::C`: The clock providing time information
- `jobs::Vector{Job}`: The jobs to be scheduled
- `ticker::Ticker{T}`: The ticker that manages timing
"""
struct TickedScheduler{C <: Clock, T} <: Scheduler
    clock::C
    jobs::Vector{Job}
    ticker::Ticker{T}
end

"""
    TickedScheduler(clock::Clock, tick_period::T) where {T}

Create a new TickedScheduler with the specified clock and tick period.
"""
function TickedScheduler(clock::Clock, tick_period::T) where {T}
    TickedScheduler(clock, Job[], Ticker(tick_period, convert(T, now(clock)), zero(tick_period)))
end

"""
    schedule!(scheduler::TickedScheduler, job::Job)

Schedule a job to be executed by the scheduler.
"""
function schedule!(scheduler::TickedScheduler, job::Job)
    push!(scheduler.jobs, job)
end

"""
    update!(scheduler::TickedScheduler)

Update the scheduler by advancing to the current time and processing available ticks.
"""
function update!(scheduler::TickedScheduler)
    current_time = now(scheduler.clock)
    advance_to!(scheduler.ticker, current_time)

    while can_tick(scheduler.ticker)
        for job in scheduler.jobs
            progress!(job, scheduler.ticker.period)
        end
        consume_tick!(scheduler.ticker)
    end
end

function get_period(scheduler::TickedScheduler)
    return scheduler.ticker.period
end