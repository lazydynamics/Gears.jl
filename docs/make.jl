using PkgName
using Documenter

DocMeta.setdocmeta!(PkgName, :DocTestSetup, :(using PkgName); recursive = true)

makedocs(;
    modules = [PkgName],
    authors = "Your Name <your.email@example.com> and contributors",
    sitename = "PkgName.jl",
    format = Documenter.HTML(;
        canonical = "https://username.github.io/PkgName.jl", edit_link = "main", assets = String[]
    ),
    pages = ["Home" => "index.md"]
)

deploydocs(; repo = "github.com/username/PkgName.jl", devbranch = "main")
