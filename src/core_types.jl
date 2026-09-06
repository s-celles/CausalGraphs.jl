using UUIDs

export NodeID, AbstractNode, EffectNode, CauseNode, IntermediateNode, CategoryNode
export RelationshipType, Causes, ContributesTo, DecomposesInto, DependsOn
export Edge, CauseEffectGraph

const NodeID = UUID

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

# Default node constructors
for T in (:EffectNode, :CauseNode, :IntermediateNode, :CategoryNode)
    @eval $T(label::String; metadata=Dict{Symbol, Any}()) = $T(uuid4(), label, metadata)
end

# Relationships
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

struct CauseEffectGraph
    nodes::Dict{NodeID, AbstractNode}
    edges::Vector{Edge}
    metadata::Dict{Symbol, Any}

    CauseEffectGraph(; metadata=Dict{Symbol, Any}()) = new(Dict{NodeID, AbstractNode}(), Edge[], metadata)
end
