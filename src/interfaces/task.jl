using Unitful
import Unitful: 𝐓

abstract type ScheduledTask end

"""
    execute(task::Task, dt::Quantity{<:Number, 𝐓})

Execute the task with the given time delta. The task decides internally whether to perform work.
"""
function execute(task::ScheduledTask, dt::Quantity{<:Number, 𝐓})
    throw(NotImplementedError("`execute` is not implemented for $(typeof(task))"))
end