module EnvironmentEngine

using Unitful
import Unitful: s, ms

export every, asap, s, ms

struct Asap end

const asap = Asap()

include("errors.jl")

include("interfaces/clock.jl")
include("interfaces/scheduler.jl")
include("interfaces/job.jl")

include("implementations/clocks/machine.jl")
include("implementations/clocks/virtual.jl")

include("every.jl")

end
