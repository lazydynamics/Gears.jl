using EnvironmentEngine
using Test
using Aqua
using JET
using TestItemRunner

@testset "EnvironmentEngine.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(EnvironmentEngine)
    end

    @testset "Code linting (JET.jl)" begin
        JET.test_package(EnvironmentEngine; target_defined_modules = true)
    end

    TestItemRunner.@run_package_tests()
end
