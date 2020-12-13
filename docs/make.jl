using Documenter

push!(LOAD_PATH,"../src/")
using MSRDPReefs

makedocs(
    sitename = "MSRDPReefs.jl",
    format = Documenter.HTML(prettyurls = false),
    pages = Any[
        "Home" => "index.md",
        "Manual" => Any[
            "data.md"
        ],
    ],
)