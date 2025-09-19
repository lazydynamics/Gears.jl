using EnvironmentEngine
using Documenter

DocMeta.setdocmeta!(EnvironmentEngine, :DocTestSetup, :(using EnvironmentEngine); recursive = true)

makedocs(;
    modules = [EnvironmentEngine],
    authors = "Lazy Dynamics and contributors",
    sitename = "EnvironmentEngine.jl",
    format = Documenter.HTML(;
        canonical = "https://lazydynamics.github.io/EnvironmentEngine.jl", edit_link = "main", assets = String[]
    ),
    pages = ["Home" => "index.md", "Getting Started" => "getting_started.md"]
)

deploydocs(; repo = "github.com/lazydynamics/EnvironmentEngine.jl", devbranch = "main")
