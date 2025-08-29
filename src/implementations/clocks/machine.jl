using Unitful

struct MachineClock <: Clock end

function now(clock::MachineClock)
    return time()u"s"
end
