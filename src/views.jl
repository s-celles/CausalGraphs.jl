export print_tree, IshikawaLayout

"""
    IshikawaLayout

A structural layout representing an Ishikawa (Fishbone) diagram.
Stores the main effect, category branches, and the underlying root causes for each category.
"""
struct IshikawaLayout
    effect::NodeID
    categories::Dict{NodeID, Vector{NodeID}}
end

function IshikawaLayout(g::Union{CauseEffectGraph, AbstractModel}, effect_id::NodeID)
    categories = Dict{NodeID, Vector{NodeID}}()
    
    # 1. Find all categories directly causing the effect
    for cause_id in direct_causes(g, effect_id)
        # Check if the node is a CategoryNode
        node = g isa CauseEffectGraph ? g.nodes[cause_id] : g.graph.nodes[cause_id]
        
        if node isa CategoryNode
            categories[cause_id] = collect(direct_causes(g, cause_id))
        end
    end
    
    return IshikawaLayout(effect_id, categories)
end

function print_tree(g::Union{CauseEffectGraph, AbstractModel}, root_id::NodeID; indent::Int=0)
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
