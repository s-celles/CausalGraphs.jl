export AbstractModel, Model, add_to_model!, compare_models

abstract type AbstractModel end

struct Model <: AbstractModel
    id::NodeID
    graph::CauseEffectGraph
    nodes::Set{NodeID}
    edges::Set{Edge}
    metadata::Dict{Symbol, Any}
end

function Model(g::CauseEffectGraph; metadata=Dict{Symbol, Any}())
    Model(uuid4(), g, Set{NodeID}(), Set{Edge}(), metadata)
end

function add_to_model!(model::AbstractModel, node_id::NodeID)
    if !haskey(model.graph.nodes, node_id)
        error("Node not found in the underlying CauseEffectGraph")
    end
    push!(model.nodes, node_id)
    return model
end

function add_to_model!(model::AbstractModel, edge::Edge)
    if !(edge in model.graph.edges)
        error("Edge not found in the underlying CauseEffectGraph")
    end
    push!(model.nodes, edge.src)
    push!(model.nodes, edge.dst)
    push!(model.edges, edge)
    return model
end

function compare_models(m1::AbstractModel, m2::AbstractModel)
    return (
        nodes_only_in_m1 = setdiff(m1.nodes, m2.nodes),
        nodes_only_in_m2 = setdiff(m2.nodes, m1.nodes),
        edges_only_in_m1 = setdiff(m1.edges, m2.edges),
        edges_only_in_m2 = setdiff(m2.edges, m1.edges)
    )
end
