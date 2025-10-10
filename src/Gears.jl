module Gears

using Unitful
import Unitful: s, ms

export asap, s, ms, global_clock, global_scheduler, set_global_clock!, set_global_scheduler!

struct Asap end

const asap = Asap()

include("utils/errors.jl")
include("utils/ticker.jl")

include("interfaces/job.jl")
include("interfaces/clock.jl")
include("interfaces/scheduler.jl")

include("implementations/clocks/machine.jl")
include("implementations/clocks/virtual.jl")

include("implementations/jobs/timed.jl")
include("implementations/jobs/event.jl")
include("implementations/jobs/asap.jl")

include("implementations/schedulers/ticked.jl")

include("utils/singletons.jl")

include("every.jl")
include("for_next.jl")

function __init__()
    set_global_clock!(MachineClock())
    set_global_scheduler!(TickedScheduler(global_clock(), 1.0u"ms"))
end
end
