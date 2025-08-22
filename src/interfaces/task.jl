using Unitful
import Unitful: 𝐓

abstract type ScheduledTask end

"""
    execute(task::Task, t::Quantity{<:Number, 𝐓})

Execute the task with the current time. The task decides internally whether to perform work.
"""
function progress!(task::ScheduledTask, t::Quantity{<:Number, 𝐓})
    throw(NotImplementedError("`execute` is not implemented for $(typeof(task))"))
end