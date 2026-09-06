module CausalGraphsMakieExt

using CausalGraphs
using MakieCore
import MakieCore: plot, plot!

# We provide a simple Makie plot recipe for CausalGraphs
# Usually, one would use GraphMakie.jl for serious graph layouts.
# This recipe is a simple fallback placeholder to show how extensions work.

# Provide a generic plot recipe for CauseEffectGraph
@recipe(PlotCausalGraph, graph) do scene
    MakieCore.Attributes(
        node_color = :lightblue,
        node_size = 20,
        edge_color = :black,
    )
end

function MakieCore.plot!(p::PlotCausalGraph{<:Tuple{<:CausalGraphs.CauseEffectGraph}})
    g = p[:graph][]
    nodes = collect(CausalGraphs.nodes_of(g))
    
    # Very naive circular layout for demonstration
    n = length(nodes)
    pos = Dict(node => (cos(2π * i / n), sin(2π * i / n)) for (i, node) in enumerate(nodes))
    
    # Plot edges
    for edge in CausalGraphs.edges_of(g)
        p1 = pos[edge.src]
        p2 = pos[edge.dst]
        MakieCore.lines!(p, [p1[1], p2[1]], [p1[2], p2[2]], color = p[:edge_color])
    end
    
    # Plot nodes
    xs = [pos[node][1] for node in nodes]
    ys = [pos[node][2] for node in nodes]
    MakieCore.scatter!(p, xs, ys, color = p[:node_color], markersize = p[:node_size])
    
    # We could also plot text labels, but we keep it minimal.
end

end
