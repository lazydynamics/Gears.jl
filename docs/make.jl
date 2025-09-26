using EnvironmentEngine
using Documenter
using DocumenterMermaid

DocMeta.setdocmeta!(EnvironmentEngine, :DocTestSetup, :(using EnvironmentEngine); recursive = true)

makedocs(;
    modules = [EnvironmentEngine],
    authors = "Lazy Dynamics and contributors",
    sitename = "EnvironmentEngine.jl",
    format = Documenter.HTML(;
        canonical = "https://lazydynamics.github.io/EnvironmentEngine.jl", edit_link = "main", assets = String[]
    ),
    pages = [
        "Home" => "index.md",
        "Getting Started" => "getting_started.md",
        "Architecture" => [
            "Overview" => "architecture/index.md",
            "C4 Model" => "architecture/c4_model.md",
            "Clocks" => "architecture/clocks.md",
            "Schedulers" => "architecture/schedulers.md",
            "Jobs" => "architecture/jobs.md"
        ]
    ]
)

deploydocs(; repo = "github.com/lazydynamics/EnvironmentEngine.jl", devbranch = "main")
