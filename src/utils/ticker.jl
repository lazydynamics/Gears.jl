using Unitful
import Unitful: Quantity, 𝐓

"""
    Ticker{T}

A mutable struct that handles time accumulation and tick processing.

# Fields
- `period::T`: The fixed tick period
- `last_tick_time::T`: The time when the last tick was processed
- `accumulated_lag::T`: Unprocessed time since the last tick
"""
mutable struct Ticker{T}
    period::T
    last_tick_time::T
    accumulated_lag::T
end

"""
    Ticker(period::Quantity{T, 𝐓}) where {T}

Create a new Ticker with the specified tick period.
"""
function Ticker(period::Quantity{T, 𝐓}) where {T}
    Ticker(period, zero(period), zero(period))
end

"""
    advance_to!(ticker::Ticker, absolute_time::Quantity{<:Number, 𝐓})

Advance the ticker to an absolute time, updating internal state accordingly.
"""
function advance_to!(ticker::Ticker, absolute_time::Quantity{<:Number, 𝐓})
    delta_t = absolute_time - (ticker.last_tick_time + ticker.accumulated_lag)
    progress!(ticker, delta_t)
    return ticker
end

"""
    progress!(ticker::Ticker, delta_time::Quantity{<:Number, 𝐓})

Progress the ticker by a delta time, updating internal state accordingly.
"""
function progress!(ticker::Ticker, delta_time::Quantity{<:Number, 𝐓})
    # Add delta time to accumulated lag
    ticker.accumulated_lag += delta_time

    return ticker
end

"""
    can_tick(ticker::Ticker)

Check if the ticker has accumulated enough time to process a tick.
"""
function can_tick(ticker::Ticker)
    return ticker.accumulated_lag >= ticker.period
end

"""
    consume_tick!(ticker::Ticker)

Consume one tick, reducing the accumulated lag by the tick period.
"""
function consume_tick!(ticker::Ticker)
    ticker.accumulated_lag -= ticker.period
    ticker.last_tick_time += ticker.period
    return ticker
end

"""
    reset!(ticker::Ticker, time::Quantity{<:Number, 𝐓})

Reset the ticker to start at the specified time with no accumulated lag.
"""
function reset!(ticker::Ticker, time::Quantity{<:Number, 𝐓})
    ticker.last_tick_time = time
    ticker.accumulated_lag = zero(time)
    return ticker
end
