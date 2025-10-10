using Gears
using Test
using Aqua
using JET
using TestItemRunner

@testset "Gears.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Gears)
    end

    @testset "Code linting (JET.jl)" begin
        JET.test_package(Gears; target_defined_modules = true)
    end

    TestItemRunner.@run_package_tests()
end
