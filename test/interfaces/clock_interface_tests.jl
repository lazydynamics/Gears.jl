@testitem "All clock implementations satisfy Clock interface" begin
    using EnvironmentEngine
    using Unitful
    import Unitful: 𝐓
    import EnvironmentEngine: Clock, now
    using InteractiveUtils

    # Get all concrete subtypes of Clock
    clock_types = subtypes(Clock)

    # Filter out abstract types (if any)
    concrete_clock_types = filter(T -> !isabstracttype(T), clock_types)

    @test length(concrete_clock_types) > 0

    foreach(concrete_clock_types) do clock_type
        clock = clock_type()

        @test hasmethod(now, (typeof(clock),))
        time_value = now(clock)
        @test typeof(time_value) <: Quantity{<:Number, 𝐓}
        @test time_value >= 0u"s"
        @test @allocated(now(clock)) == 0
    end
end