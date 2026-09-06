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
