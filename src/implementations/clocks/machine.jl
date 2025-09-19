using Unitful

export MachineClock, reset!, pause!, resume!

"""
    MachineClock

A clock that uses the system time. The time is represented in seconds.
Supports pausing and resuming to decouple logical time from system time.
The `start_time`, `pause_start_time`, and `total_paused_time` are all represented in seconds and
are wall clock (unstretched) time. Whenever `now` is called, the time is stretched by the `stretch_factor`.
This means that when the `stretch_factor` is greater than 1, the time will progress faster than the wall clock time.

# Fields
- `start_time::T`: The system time when the clock was created or last reset
- `paused::Bool`: Whether the clock is currently paused
- `total_paused_time::T`: Cumulative time spent paused
- `pause_start_time::Union{T, Nothing}`: System time when current pause started (if any)
- `stretch_factor::F`: The factor by which to stretch the time
"""
mutable struct MachineClock{T, F} <: Clock
    start_time::T
    paused::Bool
    total_paused_time::T
    pause_start_time::T
    stretch_factor::F
end

function MachineClock(; stretch_factor::F = 1.0) where {F <: Real}
    if stretch_factor <= 0
        throw(ArgumentError("Stretch factor must be positive"))
    elseif isnan(stretch_factor) || isinf(stretch_factor)
        throw(ArgumentError("Stretch factor must be a finite real number"))
    end
    ts = time()u"s"
    MachineClock(ts, true, zero(ts), ts, stretch_factor)
end

function now(clock::MachineClock)
    if clock.paused
        # If paused, return the time when pause started minus total paused time
        return (clock.pause_start_time - clock.start_time - clock.total_paused_time) * clock.stretch_factor
    else
        # If not paused, return current time minus start time minus total paused time
        return (time()u"s" - clock.start_time - clock.total_paused_time) * clock.stretch_factor
    end
end

function reset!(clock::MachineClock)
    clock.start_time = time()u"s"
    clock.paused = true
    clock.total_paused_time = zero(clock.start_time)
    clock.pause_start_time = clock.start_time
end

"""
    pause!(clock::MachineClock)

Pause the clock. While paused, logical time stops progressing.
"""
function pause!(clock::MachineClock)
    if !clock.paused
        clock.pause_start_time = time()u"s"
        clock.paused = true
    end
end

"""
    resume!(clock::MachineClock)

Resume the clock. Logical time continues from where it was paused.
"""
function resume!(clock::MachineClock)
    if clock.paused
        clock.total_paused_time += time()u"s" - clock.pause_start_time
        clock.paused = false
    end
end
