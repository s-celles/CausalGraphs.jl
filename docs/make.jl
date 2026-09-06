using Documenter
using CausalGraphs

using DocumenterLandingPage

makedocs(
    sitename="CausalGraphs.jl",
    modules=[CausalGraphs],
    format=Documenter.HTML(assets=["assets/custom-mermaid.js"], repolink="https://github.com/s-celles/CausalGraphs.jl"),
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

# Post-build: inject custom mermaid JS
index_html_path = joinpath(@__DIR__, "build", "index.html")
if isfile(index_html_path)
    html = read(index_html_path, String)
    html = replace(html, "</body>" => "<script src=\"assets/custom-mermaid.js\"></script>\n</body>")
    write(index_html_path, html)
end

deploydocs(;
    repo="github.com/s-celles/CausalGraphs.jl.git",
    devbranch="main",
)
