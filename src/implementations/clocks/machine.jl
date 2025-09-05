using Unitful

"""
    MachineClock

A clock that uses the system time. The time is represented in seconds.
"""
struct MachineClock{T} <: Clock
    start_time::T
end

MachineClock() = MachineClock(time()u"s")

function now(clock::MachineClock)
    return time()u"s" - clock.start_time
end
