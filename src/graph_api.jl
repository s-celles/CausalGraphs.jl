export add_effect!, add_cause!, add_intermediate!, add_category!, add_edge!

function add_effect!(g::CauseEffectGraph, label::String; metadata=Dict{Symbol, Any}())
    node = EffectNode(label; metadata=metadata)
    g.nodes[node.id] = node
    return node.id
end

function add_category!(g::CauseEffectGraph, label::String; metadata=Dict{Symbol, Any}())
    node = CategoryNode(label; metadata=metadata)
    g.nodes[node.id] = node
    return node.id
end

function add_intermediate!(g::CauseEffectGraph, label::String; metadata=Dict{Symbol, Any}())
    node = IntermediateNode(label; metadata=metadata)
    g.nodes[node.id] = node
    return node.id
end

function add_cause!(g::CauseEffectGraph, label::String; metadata=Dict{Symbol, Any}())
    node = CauseNode(label; metadata=metadata)
    g.nodes[node.id] = node
    return node.id
end

# Helper to add a cause and link it to a parent (e.g. a category or an effect)
function add_cause!(g::CauseEffectGraph, parent_id::NodeID, label::String; 
                    rel::RelationshipType=DecomposesInto(), metadata=Dict{Symbol, Any}())
    cause_id = add_cause!(g, label; metadata=metadata)
    add_edge!(g, cause_id, parent_id, rel)
    return cause_id
end

function add_edge!(g::CauseEffectGraph, src::NodeID, dst::NodeID, rel::RelationshipType=Causes(); metadata=Dict{Symbol, Any}())
    if !haskey(g.nodes, src) || !haskey(g.nodes, dst)
        error("Source or destination node not found in graph")
    end
    edge = Edge(src, dst, rel; metadata=metadata)
    push!(g.edges, edge)
    return edge
end
