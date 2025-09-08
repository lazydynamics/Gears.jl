using Unitful

export MachineClock, reset!, pause!, resume!

"""
    MachineClock

A clock that uses the system time. The time is represented in seconds.
Supports pausing and resuming to decouple logical time from system time.

# Fields
- `start_time::T`: The system time when the clock was created or last reset
- `paused::Bool`: Whether the clock is currently paused
- `total_paused_time::T`: Cumulative time spent paused
- `pause_start_time::Union{T, Nothing}`: System time when current pause started (if any)
"""
mutable struct MachineClock{T} <: Clock
    start_time::T
    paused::Bool
    total_paused_time::T
    pause_start_time::T
end

function MachineClock()
    ts = time()u"s"
    MachineClock(ts, true, zero(ts), ts)
end

function now(clock::MachineClock)
    if clock.paused
        # If paused, return the time when pause started minus total paused time
        return clock.pause_start_time - clock.start_time - clock.total_paused_time
    else
        # If not paused, return current time minus start time minus total paused time
        return time()u"s" - clock.start_time - clock.total_paused_time
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
        # Add the time spent paused to total paused time
        clock.total_paused_time += time()u"s" - clock.pause_start_time
        clock.paused = false
        # clock.pause_start_time = nothing
    end
end
