abstract type Clock end

"""
    now(clock::Clock)

Returns the current time in the clock using Unitful to represent the unit of time.
"""
function now(clock::Clock)
    throw(NotImplementedError("`now` is not implemented for $(typeof(clock))"))
end