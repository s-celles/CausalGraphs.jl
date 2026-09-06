export add_effect!, add_cause!, add_intermediate!, add_category!, add_edge!
using Graphs

function _add_node_internal!(g::CauseEffectGraph, node::AbstractNode)
    g.nodes[node.id] = node
    # Add to Graphs.jl backend
    Graphs.add_vertex!(g.graph)
    v = nv(g.graph)
    g.node_to_int[node.id] = v
    g.int_to_node[v] = node.id
    return node.id
end

"""
    add_effect!
"""
function add_effect!(g::CauseEffectGraph, label::String; metadata=Dict{Symbol, Any}())
    node = EffectNode(label; metadata=metadata)
    return _add_node_internal!(g, node)
end

"""
    add_category!
"""
function add_category!(g::CauseEffectGraph, label::String; metadata=Dict{Symbol, Any}())
    node = CategoryNode(label; metadata=metadata)
    return _add_node_internal!(g, node)
end

"""
    add_intermediate!
"""
function add_intermediate!(g::CauseEffectGraph, label::String; metadata=Dict{Symbol, Any}())
    node = IntermediateNode(label; metadata=metadata)
    return _add_node_internal!(g, node)
end

"""
    add_cause!
"""
function add_cause!(g::CauseEffectGraph, label::String; metadata=Dict{Symbol, Any}())
    node = CauseNode(label; metadata=metadata)
    return _add_node_internal!(g, node)
end

"""
    add_cause!
"""
function add_cause!(g::CauseEffectGraph, parent_id::NodeID, label::String; 
                    rel::RelationshipType=DecomposesInto(), metadata=Dict{Symbol, Any}())
    cause_id = add_cause!(g, label; metadata=metadata)
    add_edge!(g, cause_id, parent_id, rel)
    return cause_id
end

"""
    add_edge!
"""
function add_edge!(g::CauseEffectGraph, src::NodeID, dst::NodeID, rel::RelationshipType=Causes(); metadata=Dict{Symbol, Any}())
    if !haskey(g.nodes, src) || !haskey(g.nodes, dst)
        error("Source or destination node not found in graph")
    end
    
    u = g.node_to_int[src]
    v = g.node_to_int[dst]
    
    # Check for acyclicity constraint (DAG) before adding
    # If adding this edge would create a cycle, reject it.
    if Graphs.has_path(g.graph, v, u)
        error("Adding this edge would create a cycle. Causal graphs must be Directed Acyclic Graphs (DAGs).")
    end
    
    Graphs.add_edge!(g.graph, u, v)
    edge_obj = Edge(src, dst, rel; metadata=metadata)
    g.edges_info[Graphs.Edge(u, v)] = edge_obj
    return edge_obj
end
