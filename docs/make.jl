using Documenter

push!(LOAD_PATH,"../src/")
using AbstractPlotting
using MSRDPReefs

makedocs(
    sitename = "MSRDPReefs.jl",
    format = Documenter.HTML(prettyurls = false),
    pages = Any[
        "Home" => "index.md",
        "Manual" => Any[
            "data.md",
            "clustutils.md"
        ],
    ],
)

deploydocs(
  repo = "github.com/ymtoo/MSRDPReefs.jl",
  branch = "gh-pages",
)