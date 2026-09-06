export print_tree, IshikawaLayout, to_dot, to_mermaid, to_ishikawa

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

"""
    print_tree(g, root_id; indent)

Prints a text-based tree representation of the causal graph.
"""
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

"""
    to_dot(g)

Generates a GraphViz DOT string representation of the graph.
"""
function to_dot(g::Union{CauseEffectGraph, AbstractModel})
    io = IOBuffer()
    println(io, "digraph CausalGraph {")
    println(io, "    rankdir=LR;"); println(io, "    bgcolor=\"white\";")
    println(io, "    node [shape=box, style=rounded, fontname=\"Helvetica\"];")
    println(io, "    edge [fontname=\"Helvetica\", fontsize=10];")
    
    # Write nodes
    for id in nodes_of(g)
        # Handle nodes from graph or model
        node = g isa CauseEffectGraph ? g.nodes[id] : g.graph.nodes[id]
        
        shape = if node isa EffectNode
            "ellipse"
        elseif node isa CategoryNode
            "parallelogram"
        else
            "box"
        end
        
        style = node isa EffectNode ? "filled,rounded" : "rounded"
        fillcolor = node isa EffectNode ? "#e0e0e0" : "white"
        
        # Format id to be a valid dot identifier (replace hyphens if UUID)
        safe_id = replace(string(id), "-" => "_")
        println(io, "    \"$(safe_id)\" [label=\"$(node.label)\", shape=\"$(shape)\", style=\"$(style)\", fillcolor=\"$(fillcolor)\"];")
    end
    
    # Write edges
    for edge in edges_of(g)
        safe_src = replace(string(edge.src), "-" => "_")
        safe_dst = replace(string(edge.dst), "-" => "_")
        label = string(edge.rel)
        println(io, "    \"$(safe_src)\" -> \"$(safe_dst)\" [label=\"$(label)\"];")
    end
    
    println(io, "}")
    return String(take!(io))
end


"""
    to_mermaid(g; direction="LR")

Generates a Mermaid JS graph string representation of the causal graph.
"""
function to_mermaid(g::Union{CauseEffectGraph, AbstractModel}; direction="LR")
    io = IOBuffer()
    println(io, "graph ", direction)
    
    for id in nodes_of(g)
        node = g isa CauseEffectGraph ? g.nodes[id] : g.graph.nodes[id]
        safe_id = replace(string(id), "-" => "_")
        
        # Mermaid shapes: [] for box, (()) for circle, >] for flag/asymmetric
        shape_start, shape_end = if node isa EffectNode
            ("((", "))")
        elseif node isa CategoryNode
            (">", "]")
        else
            ("[", "]")
        end
        
        # Escape quotes in label
        label = replace(node.label, "\"" => "\\\"")
        println(io, "    ", safe_id, shape_start, "\"", label, "\"", shape_end)
    end
    
    for edge in edges_of(g)
        safe_src = replace(string(edge.src), "-" => "_")
        safe_dst = replace(string(edge.dst), "-" => "_")
        label = string(edge.rel)
        println(io, "    ", safe_src, " -- \"", label, "\" --> ", safe_dst)
    end
    
    return String(take!(io))
end

"""
    to_ishikawa(g)

Generates a Mermaid JS Ishikawa (fishbone) string representation of the causal graph.
Assumes the graph contains one main effect and categories linked to it.
"""
function to_ishikawa(g::Union{CauseEffectGraph, AbstractModel})
    nodes_dict = g isa CauseEffectGraph ? g.nodes : g.graph.nodes
    effect_id = first(id for (id, n) in nodes_dict if n isa EffectNode)
    layout = IshikawaLayout(g, effect_id)
    
    io = IOBuffer()
    println(io, "ishikawa")
    println(io, "  ", nodes_dict[layout.effect].label)
    
    for (cat, causes) in layout.categories
        println(io, "    ", nodes_dict[cat].label)
        for cause in causes
            println(io, "      ", nodes_dict[cause].label)
            sub_causes = [nodes_dict[e.src] for e in edges_of(g) if e.dst == cause && nodes_dict[e.src] isa CauseNode]
            for sub_cause in sub_causes
                println(io, "        ", sub_nodes_dict[cause].label)
            end
        end
    end
    
    return String(take!(io))
end

# Overload Base.show for nice text and IDE representations
import Base: show

function show(io::IO, ::MIME"text/plain", g::Union{CauseEffectGraph, AbstractModel})
    println(io, typeof(g), " with ", length(nodes_of(g)), " nodes and ", length(edges_of(g)), " edges.")
    
    # Optionally, we could print the tree of root causes if there is one clear effect
    roots = root_causes(g)
    effects = [n for n in nodes_of(g) if isempty(direct_effects(g, n))]
    
    if !isempty(effects)
        println(io, "Tree view (from primary effects):")
        for eff in effects
            print_tree(g, eff)
        end
    end
end

function show(io::IO, ::MIME"text/vnd.graphviz", g::Union{CauseEffectGraph, AbstractModel})
    print(io, to_dot(g))
end
