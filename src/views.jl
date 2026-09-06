export print_tree

function print_tree(g::Union{CauseEffectGraph, Model}, root_id::NodeID; indent::Int=0)
    # Only applicable if the root_id exists in the graph or model
    if !(root_id in nodes_of(g))
        return
    end
    
    node = g.graph.nodes[root_id] # if it's a Model, nodes are stored in graph.nodes
    println(" "^indent, "└─ ", node.label, " (", nameof(typeof(node)), ")")
    
    for cause_id in direct_causes(g, root_id)
        print_tree(g, cause_id, indent=indent+4)
    end
end

# Specialization for CauseEffectGraph
function print_tree(g::CauseEffectGraph, root_id::NodeID; indent::Int=0)
    if !haskey(g.nodes, root_id)
        return
    end
    
    node = g.nodes[root_id]
    println(" "^indent, "└─ ", node.label, " (", nameof(typeof(node)), ")")
    
    for cause_id in direct_causes(g, root_id)
        print_tree(g, cause_id; indent=indent+4)
    end
end
