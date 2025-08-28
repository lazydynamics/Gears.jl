module EnvironmentEngine

using Unitful
import Unitful: s, ms

export every, asap, s, ms

struct Asap end

const asap = Asap()

include("errors.jl")
include("utils/ticker.jl")

include("interfaces/job.jl")
include("interfaces/clock.jl")
include("interfaces/scheduler.jl")

include("implementations/clocks/machine.jl")
include("implementations/clocks/virtual.jl")

include("implementations/jobs/timed.jl")

include("implementations/schedulers/ticked.jl")

include("every.jl")

end
