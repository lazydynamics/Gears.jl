using Unitful
import Unitful: Quantity, 𝐓
import EnvironmentEngine: Ticker

"""
    TimedJob{F, T}

A job that executes at regular time intervals.

# Fields
- `f::F`: The function to execute
- `ticker::Ticker{T}`: The ticker that manages timing
"""
struct TimedJob{F, T} <: Job
    f::F
    ticker::Ticker{T}
end

"""
    TimedJob(f, period::Quantity{T, 𝐓}) where {T}

Create a new TimedJob with the specified function and tick period.
"""
function TimedJob(f, period::Quantity{T, 𝐓}) where {T}
    TimedJob(f, Ticker(period))
end

"""
    progress!(job::TimedJob, dt::Quantity{<:Number, 𝐓})

Progress the job by the specified time delta, executing the function for each available tick.
"""
function progress!(job::TimedJob, dt::Quantity{<:Number, 𝐓})
    progress!(job.ticker, dt)

    while can_tick(job.ticker)
        job.f(job.ticker.period)
        consume_tick!(job.ticker)
    end
end

function get_period(job::TimedJob)
    return job.ticker.period
end

function get_lag(job::TimedJob)
    return job.ticker.accumulated_lag
end