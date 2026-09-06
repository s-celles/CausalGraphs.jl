using Documenter
using CausalGraphs
using DocumenterLandingPage

makedocs(
    sitename="CausalGraphs.jl",
    modules=[CausalGraphs],
    format=Documenter.HTML(),
    plugins=[
        LandingPage()
    ],
    pages=[
        "Home" => "index.md",
    ]
)

# Copy llms.txt and llms-full.txt to the build directory so they are served at the root of the docs site
cp(joinpath(@__DIR__, "src", "llms.txt"), joinpath(@__DIR__, "build", "llms.txt"); force=true)
cp(joinpath(@__DIR__, "src", "llms-full.txt"), joinpath(@__DIR__, "build", "llms-full.txt"); force=true)
