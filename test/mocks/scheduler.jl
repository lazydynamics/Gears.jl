@testmodule MockSchedulers begin
    using Unitful

    mutable struct MockScheduler <: Scheduler
        clock::Clock
        tasks::Vector{Task}
        time::Quantity{Int64, 𝐓, Unitful.FreeUnits{(s,), 𝐓, nothing}}
    end

    function schedule!(scheduler::MockScheduler, task::Task)
        push!(scheduler.tasks, task)
    end

    function run!(scheduler::MockScheduler)
        for task in scheduler.tasks
            execute(task, 1u"us")
        end
        scheduler.time += 1u"us"
    end

    function get_clock(scheduler::MockScheduler)
        return scheduler.clock
    end
end