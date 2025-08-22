using PkgName
using Test
using Aqua
using JET
using TestItemRunner

@testset "PkgName.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(PkgName)
    end

    @testset "Code linting (JET.jl)" begin
        JET.test_package(PkgName; target_defined_modules = true)
    end

    TestItemRunner.@run_package_tests()
end
