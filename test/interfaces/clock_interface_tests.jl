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

    for clock_type in concrete_clock_types
        # Test that we can instantiate the clock
        clock = clock_type()

        # Test that now() method exists and returns correct type
        @test hasmethod(now, (typeof(clock),))

        # Test that now() returns a time quantity
        time_value = now(clock)
        @test typeof(time_value) <: Quantity{<:Number, 𝐓}

        # Test that time values are comparable
        @test time_value >= 0u"s"
    end
end