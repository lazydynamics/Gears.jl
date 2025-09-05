export for_next

function for_next(f::Function, clock::Clock, duration::Quantity{<:Number, 𝐓})
    start_time = now(clock)
    end_time = start_time + duration
    while now(clock) < end_time
        f()
        if now(clock) == start_time
            error("Livelock detected: time did not progress within an iteration of the loop")
        end
    end
end

for_next(f::Function, duration::Quantity{<:Number, 𝐓}) = for_next(f, global_clock(), duration)