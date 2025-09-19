using Unitful
using Base.Threads
using Static

export TickedScheduler

"""
    TickedScheduler{C <: Clock, T} <: Scheduler

A scheduler that processes jobs at regular tick intervals.

# Fields
- `clock::C`: The clock providing time information
- `jobs::Vector{Job}`: The jobs to be scheduled
- `ticker::Ticker{T}`: The ticker that manages timing
"""
struct TickedScheduler{C <: Clock, T, V, B} <: Scheduler
    clock::C
    jobs::V
    ticker::Ticker{T}
    threading::B
end

"""
    TickedScheduler(clock::Clock, tick_period::T) where {T}

Create a new TickedScheduler with the specified clock and tick period.
"""
function TickedScheduler(clock::Clock, tick_period::T; threading::Bool = false) where {T}
    tick_period = convert(Quantity{Float64}, tick_period)
    TickedScheduler(
        clock,
        Job[],
        Ticker(tick_period, convert(typeof(tick_period), now(clock)), zero(tick_period)),
        static(threading)
    )
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
        _process_jobs!(scheduler)
        consume_tick!(scheduler.ticker)
    end
end

function _process_jobs!(scheduler::TickedScheduler{C, T, V, <:False}) where {C, T, V}
    foreach(scheduler.jobs) do job
        progress!(job, scheduler.ticker.period)
    end
end

function _process_jobs!(scheduler::TickedScheduler{C, T, V, <:True}) where {C, T, V}
    tasks = map(scheduler.jobs) do job
        @spawn progress!(job, scheduler.ticker.period)
    end
    wait.(tasks)
end

function get_period(scheduler::TickedScheduler)
    return scheduler.ticker.period
end

function compile(scheduler::TickedScheduler)
    return TickedScheduler(scheduler.clock, (scheduler.jobs...,), scheduler.ticker, scheduler.threading)
end
