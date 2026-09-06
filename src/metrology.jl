export MeasurementModel, set_output!, add_input!

mutable struct MeasurementModel <: AbstractModel
    id::NodeID
    graph::CauseEffectGraph
    nodes::Set{NodeID}
    edges::Set{Edge}
    inputs::Set{NodeID}
    output::Union{Nothing, NodeID}
    metadata::Dict{Symbol, Any}
end

function MeasurementModel(g::CauseEffectGraph; metadata=Dict{Symbol, Any}())
    MeasurementModel(uuid4(), g, Set{NodeID}(), Set{Edge}(), Set{NodeID}(), nothing, metadata)
end

function set_output!(m::MeasurementModel, node_id::NodeID)
    if !haskey(m.graph.nodes, node_id)
        error("Output node not found in graph")
    end
    push!(m.nodes, node_id)
    m.output = node_id
    return m
end

function add_input!(m::MeasurementModel, node_id::NodeID)
    if !haskey(m.graph.nodes, node_id)
        error("Input node not found in graph")
    end
    push!(m.nodes, node_id)
    push!(m.inputs, node_id)
    return m
end
