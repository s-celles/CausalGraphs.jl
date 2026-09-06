using JSON
using UUIDs

export write_json, read_json

# Convert nodes and edges to Dicts for JSON serialization
function to_dict(n::EffectNode)
    Dict("type" => "EffectNode", "id" => string(n.id), "label" => n.label, "metadata" => n.metadata)
end
function to_dict(n::CauseNode)
    Dict("type" => "CauseNode", "id" => string(n.id), "label" => n.label, "metadata" => n.metadata)
end
function to_dict(n::IntermediateNode)
    Dict("type" => "IntermediateNode", "id" => string(n.id), "label" => n.label, "metadata" => n.metadata)
end
function to_dict(n::CategoryNode)
    Dict("type" => "CategoryNode", "id" => string(n.id), "label" => n.label, "metadata" => n.metadata)
end

function to_dict(r::RelationshipType)
    string(typeof(r))
end

function to_dict(e::Edge)
    Dict("src" => string(e.src), "dst" => string(e.dst), "rel" => to_dict(e.rel), "metadata" => e.metadata)
end

function to_dict(g::CauseEffectGraph)
    Dict(
        "nodes" => [to_dict(n) for n in values(g.nodes)],
        "edges" => [to_dict(e) for e in g.edges],
        "metadata" => g.metadata
    )
end

function write_json(g::CauseEffectGraph, path::String)
    open(path, "w") do f
        JSON.print(f, to_dict(g), 4)
    end
end

# Deserialization
function node_from_dict(d::AbstractDict)
    id = UUID(d["id"])
    label = d["label"]
    # JSON converts Dict{Symbol, Any} to Dict{String, Any}, we convert back
    metadata = Dict{Symbol, Any}(Symbol(k) => v for (k, v) in d["metadata"])
    
    type_str = d["type"]
    if type_str == "EffectNode"
        return EffectNode(id, label, metadata)
    elseif type_str == "CauseNode"
        return CauseNode(id, label, metadata)
    elseif type_str == "IntermediateNode"
        return IntermediateNode(id, label, metadata)
    elseif type_str == "CategoryNode"
        return CategoryNode(id, label, metadata)
    else
        error("Unknown node type: $type_str")
    end
end

function rel_from_string(s::String)
    # Strip any module names like CausalGraphs.Causes if they got appended
    s = split(s, ".")[end]
    if s == "Causes"
        return Causes()
    elseif s == "ContributesTo"
        return ContributesTo()
    elseif s == "DecomposesInto"
        return DecomposesInto()
    elseif s == "DependsOn"
        return DependsOn()
    else
        error("Unknown relationship type: $s")
    end
end

function edge_from_dict(d::AbstractDict)
    src = UUID(d["src"])
    dst = UUID(d["dst"])
    rel = rel_from_string(d["rel"])
    metadata = Dict{Symbol, Any}(Symbol(k) => v for (k, v) in d["metadata"])
    return Edge(src, dst, rel; metadata=metadata)
end

function read_json(path::String)
    data = JSON.parsefile(path)
    metadata = Dict{Symbol, Any}(Symbol(k) => v for (k, v) in data["metadata"])
    g = CauseEffectGraph(metadata=metadata)
    
    for n_dict in data["nodes"]
        n = node_from_dict(n_dict)
        g.nodes[n.id] = n
    end
    
    for e_dict in data["edges"]
        e = edge_from_dict(e_dict)
        push!(g.edges, e)
    end
    
    return g
end
