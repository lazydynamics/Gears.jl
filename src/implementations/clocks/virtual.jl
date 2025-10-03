using Unitful
import Unitful: 𝐓

export VirtualClock, advance_time!, set_time!

"""
    VirtualClock

A clock that uses virtual time for simulations. The time is represented in seconds.

# Fields
- `current_time::T`: The current time of the clock

This clock can be advanced with the `advance_time!` function.
"""
mutable struct VirtualClock{T} <: Clock
    current_time::T
end

VirtualClock{T}() where {T} = VirtualClock(zero(T)s)

VirtualClock() = VirtualClock{Float64}()

function now(clock::VirtualClock{T}) where {T}
    return clock.current_time
end

"""
    set_time!(clock::VirtualClock{T}, time::Quantity{<:Number, 𝐓})

Set the time of the clock. Uses `Unitful.jl` for time units.
"""
function set_time!(clock::VirtualClock{T}, time::Quantity{<:Number, 𝐓}) where {T}
    clock.current_time = time
end

"""
    advance_time!(clock::VirtualClock{T}, dt::Quantity{<:Number, 𝐓})

Advance the time of the clock by a given duration. Uses `Unitful.jl` for time units.
"""
function advance_time!(clock::VirtualClock{T}, dt::Quantity{<:Number, 𝐓}) where {T}
    clock.current_time += dt
end
