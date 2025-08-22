using Unitful
import Unitful: 𝐓

struct VirtualClock{T} <: Clock
    current_time::T
end

VirtualClock{T}() where {T} = VirtualClock(zero(T)s)

VirtualClock() = VirtualClock{Float64}()

function now(clock::VirtualClock{T}) where {T}
    return clock.current_time
end

function set_time!(clock::VirtualClock{T}, time::Quantity{<:Number, 𝐓}) where {T}
    clock.current_time = time
end

function advance_time!(clock::VirtualClock{T}, dt::Quantity{<:Number, 𝐓}) where {T}
    clock.current_time += dt
end