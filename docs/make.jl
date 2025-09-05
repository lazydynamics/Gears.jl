using EnvironmentEngine
using Documenter

DocMeta.setdocmeta!(EnvironmentEngine, :DocTestSetup, :(using EnvironmentEngine); recursive = true)

makedocs(;
    modules = [EnvironmentEngine],
    authors = "lazydynamics and contributors",
    sitename = "EnvironmentEngine.jl",
    format = Documenter.HTML(;
        canonical = "https://lazydynamics.github.io/EnvironmentEngine.jl", edit_link = "main", assets = String[]
    ),
    pages = [
        "Home" => "index.md",
        "Getting Started" => "getting_started.md",
        "API Specifications" => [
            "Drone Environment" => "api_spec/drone.md",
            "Farama Gym Environment" => "api_spec/farama.md",
            "Multi-Agent Environment" => "api_spec/multi_agent.md"
        ]
    ]
)

deploydocs(; repo = "github.com/lazydynamics/EnvironmentEngine.jl", devbranch = "main")
