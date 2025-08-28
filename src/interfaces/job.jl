using Unitful
import Unitful: 𝐓

abstract type Job end

"""
    execute(job::Job, t::Quantity{<:Number, 𝐓})

Execute the job with the current time. The job decides internally whether to perform work.
"""
function progress!(job::Job, t::Quantity{<:Number, 𝐓})
    throw(NotImplementedError("`execute` is not implemented for $(typeof(job))"))
end