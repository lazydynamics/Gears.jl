using Unitful

struct VirtualClock <: Clock
    current_time::Quantity{Int64, 𝐓, Unitful.FreeUnits{(s,), 𝐓, nothing}}
end