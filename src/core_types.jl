using UUIDs
using Graphs
import Graphs: nv, ne, vertices, edges, has_vertex, has_edge, inneighbors, outneighbors, is_directed, edgetype, eltype

export NodeID, AbstractNode, EffectNode, CauseNode, IntermediateNode, CategoryNode
export RelationshipType, Causes, ContributesTo, DecomposesInto, DependsOn
export Edge, CauseEffectGraph

"""
    NodeID
"""
const NodeID = UUID

"""
    AbstractNode
"""
abstract type AbstractNode end

struct EffectNode <: AbstractNode
    id::NodeID
    label::String
    metadata::Dict{Symbol, Any}
end

struct CauseNode <: AbstractNode
    id::NodeID
    label::String
    metadata::Dict{Symbol, Any}
end

struct IntermediateNode <: AbstractNode
    id::NodeID
    label::String
    metadata::Dict{Symbol, Any}
end

struct CategoryNode <: AbstractNode
    id::NodeID
    label::String
    metadata::Dict{Symbol, Any}
end

for T in (:EffectNode, :CauseNode, :IntermediateNode, :CategoryNode)
    @eval $T(label::String; metadata=Dict{Symbol, Any}()) = $T(uuid4(), label, metadata)
end

abstract type RelationshipType end
struct Causes <: RelationshipType end
struct ContributesTo <: RelationshipType end
struct DecomposesInto <: RelationshipType end
struct DependsOn <: RelationshipType end

struct Edge
    src::NodeID
    dst::NodeID
    rel::RelationshipType
    metadata::Dict{Symbol, Any}
end
Edge(src::NodeID, dst::NodeID, rel::RelationshipType; metadata=Dict{Symbol, Any}()) = Edge(src, dst, rel, metadata)

"""
    CauseEffectGraph

A Causal Graph acting as a valid `Graphs.AbstractGraph{Int}` for seamless integration with the Graphs.jl ecosystem.
"""
struct CauseEffectGraph <: AbstractGraph{Int}
    graph::SimpleDiGraph{Int}
    nodes::Dict{NodeID, AbstractNode}
    edges_info::Dict{Graphs.SimpleEdge{Int}, Edge}
    
    # Mappings to bridge Graphs.jl (Int) and our domain (UUID)
    node_to_int::Dict{NodeID, Int}
    int_to_node::Dict{Int, NodeID}
    metadata::Dict{Symbol, Any}

    function CauseEffectGraph(; metadata=Dict{Symbol, Any}())
        new(SimpleDiGraph{Int}(), Dict(), Dict(), Dict(), Dict(), metadata)
    end
end

# ---------------------------------------------------------
# Graphs.jl Interface Implementation
# ---------------------------------------------------------

Graphs.nv(g::CauseEffectGraph) = nv(g.graph)
Graphs.ne(g::CauseEffectGraph) = ne(g.graph)
Graphs.vertices(g::CauseEffectGraph) = vertices(g.graph)
Graphs.edges(g::CauseEffectGraph) = edges(g.graph)
Graphs.is_directed(::Type{CauseEffectGraph}) = true
Graphs.is_directed(::CauseEffectGraph) = true
Graphs.eltype(g::CauseEffectGraph) = Int
Graphs.edgetype(g::CauseEffectGraph) = Graphs.SimpleEdge{Int}

Graphs.has_vertex(g::CauseEffectGraph, v::Int) = has_vertex(g.graph, v)
Graphs.has_edge(g::CauseEffectGraph, s::Int, d::Int) = has_edge(g.graph, s, d)

Graphs.inneighbors(g::CauseEffectGraph, v::Int) = inneighbors(g.graph, v)
Graphs.outneighbors(g::CauseEffectGraph, v::Int) = outneighbors(g.graph, v)

# Utilities to convert between domain and graph index
Base.getindex(g::CauseEffectGraph, id::NodeID) = g.node_to_int[id]
Base.getindex(g::CauseEffectGraph, v::Int) = g.int_to_node[v]
