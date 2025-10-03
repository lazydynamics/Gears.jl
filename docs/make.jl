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
        "Quick Start" => "quickstart.md",
        "Tutorials" => [
            "Overview" => "tutorials/index.md",
            "Basic Scheduling" => "tutorials/basic_scheduling.md",
            "Clocks and Time" => "tutorials/clocks_and_time.md",
            "Schedulers" => "tutorials/schedulers.md",
            "Job Types" => "tutorials/job_types.md",
            "Threading" => "tutorials/threading.md"
        ],
        "User Guide" => [
            "Overview" => "user_guide/index.md",
            "API Reference" => "user_guide/api_reference.md",
            "Sharp Bits" => "user_guide/sharp_bits.md"
        ],
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
