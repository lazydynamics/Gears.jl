@testmodule MockTasks begin
    struct MockTask <: Task
        f
    end

    function execute(task::MockTask, dt::Quantity{<:Number, 𝐓})
        task.f()
    end
end