"""
    Global singleton objects for the EnvironmentEngine package.

This module provides global access to a clock and scheduler that can be configured
with specific instances while maintaining type stability through function barriers.
"""

# Internal storage for global instances (type-unstable, but isolated)
const _global_clock = Ref{Any}(MachineClock())
const _global_scheduler = Ref{Any}(TickedScheduler(MachineClock(), 1.0u"s"))

"""
    global_clock()

Returns the global clock instance.

Note: This function is type-unstable but the type instability is isolated
by function barriers in the calling code.
"""
function global_clock()
    _global_clock[]
end

"""
    global_scheduler()

Returns the global scheduler instance.

Note: This function is type-unstable but the type instability is isolated
by function barriers in the calling code.
"""
function global_scheduler()
    _global_scheduler[]
end

"""
    set_global_clock!(clock::Clock)

Sets the global clock to the specified instance.

# Arguments
- `clock::Clock`: The clock instance to use globally
"""
function set_global_clock!(clock::Clock)
    _global_clock[] = clock
end

"""
    set_global_scheduler!(scheduler::Scheduler)

Sets the global scheduler to the specified instance.

# Arguments
- `scheduler::Scheduler`: The scheduler instance to use globally
"""
function set_global_scheduler!(scheduler::Scheduler)
    _global_scheduler[] = scheduler
end

"""
    reset_global_clock!()

Resets the global clock to the default MachineClock instance.
"""
function reset_global_clock!()
    _global_clock[] = MachineClock()
end

"""
    reset_global_scheduler!()

Resets the global scheduler to the default TickedScheduler instance.
"""
function reset_global_scheduler!()
    _global_scheduler[] = TickedScheduler(MachineClock(), 1.0u"s")
end
