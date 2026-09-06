export direct_causes, direct_effects, ancestors, descendants, root_causes

edges_of(g::CauseEffectGraph) = g.edges
edges_of(m::Model) = m.edges
nodes_of(g::CauseEffectGraph) = keys(g.nodes)
nodes_of(m::Model) = m.nodes

function direct_causes(g::Union{CauseEffectGraph, Model}, node_id::NodeID)
    causes = Set{NodeID}()
    for edge in edges_of(g)
        if edge.dst == node_id
            push!(causes, edge.src)
        end
    end
    return causes
end

function direct_effects(g::Union{CauseEffectGraph, Model}, node_id::NodeID)
    effects = Set{NodeID}()
    for edge in edges_of(g)
        if edge.src == node_id
            push!(effects, edge.dst)
        end
    end
    return effects
end

function ancestors(g::Union{CauseEffectGraph, Model}, node_id::NodeID)
    visited = Set{NodeID}()
    queue = [node_id]
    
    while !isempty(queue)
        current = popfirst!(queue)
        for cause in direct_causes(g, current)
            if !(cause in visited)
                push!(visited, cause)
                push!(queue, cause)
            end
        end
    end
    return visited
end

function descendants(g::Union{CauseEffectGraph, Model}, node_id::NodeID)
    visited = Set{NodeID}()
    queue = [node_id]
    
    while !isempty(queue)
        current = popfirst!(queue)
        for effect in direct_effects(g, current)
            if !(effect in visited)
                push!(visited, effect)
                push!(queue, effect)
            end
        end
    end
    return visited
end

function root_causes(g::Union{CauseEffectGraph, Model})
    roots = Set{NodeID}()
    for id in nodes_of(g)
        if isempty(direct_causes(g, id))
            push!(roots, id)
        end
    end
    return roots
end
export paths, has_cycles, is_valid

# Find all paths between src and dst
function paths(g::Union{CauseEffectGraph, AbstractModel}, src::NodeID, dst::NodeID)
    all_paths = Vector{Vector{NodeID}}()
    
    function dfs(current::NodeID, current_path::Vector{NodeID})
        push!(current_path, current)
        if current == dst
            push!(all_paths, copy(current_path))
        else
            for effect in direct_effects(g, current)
                if !(effect in current_path) # avoid cycles
                    dfs(effect, current_path)
                end
            end
        end
        pop!(current_path)
    end
    
    dfs(src, Vector{NodeID}())
    return all_paths
end

# Check if the graph has any cycles (must be a DAG for causal modeling in most cases)
function has_cycles(g::Union{CauseEffectGraph, AbstractModel})
    visited = Set{NodeID}()
    rec_stack = Set{NodeID}()
    
    function is_cyclic(node::NodeID)
        if !(node in visited)
            push!(visited, node)
            push!(rec_stack, node)
            
            for effect in direct_effects(g, node)
                if !(effect in visited) && is_cyclic(effect)
                    return true
                elseif effect in rec_stack
                    return true
                end
            end
        end
        delete!(rec_stack, node)
        return false
    end
    
    for id in nodes_of(g)
        if is_cyclic(id)
            return true
        end
    end
    return false
end

# Check if a model is valid
function is_valid(m::AbstractModel)
    # A model is valid if all edges reference nodes that are also in the model
    # and if it has no cycles
    if has_cycles(m)
        return false
    end
    
    for edge in edges_of(m)
        if !(edge.src in nodes_of(m)) || !(edge.dst in nodes_of(m))
            return false
        end
    end
    return true
end
