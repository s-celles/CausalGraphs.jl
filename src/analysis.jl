export direct_causes, direct_effects, ancestors, descendants, root_causes

edges_of(g::CauseEffectGraph) = values(g.edges_info)
edges_of(m::Model) = m.edges
nodes_of(g::CauseEffectGraph) = keys(g.nodes)
nodes_of(m::Model) = m.nodes

"""
    direct_causes
"""
function direct_causes(g::CauseEffectGraph, node_id::NodeID)
    v = g.node_to_int[node_id]
    return Set(g.int_to_node[p] for p in inneighbors(g.graph, v))
end

function direct_causes(m::Model, node_id::NodeID)
    causes = Set{NodeID}()
    for edge in edges_of(m)
        if edge.dst == node_id
            push!(causes, edge.src)
        end
    end
    return causes
end

"""
    direct_effects
"""
function direct_effects(g::CauseEffectGraph, node_id::NodeID)
    v = g.node_to_int[node_id]
    return Set(g.int_to_node[c] for c in outneighbors(g.graph, v))
end

function direct_effects(m::Model, node_id::NodeID)
    effects = Set{NodeID}()
    for edge in edges_of(m)
        if edge.src == node_id
            push!(effects, edge.dst)
        end
    end
    return effects
end

"""
    ancestors
"""
function ancestors(g::CauseEffectGraph, node_id::NodeID)
    v = g.node_to_int[node_id]
    # bfs_tree from the node using :in direction
    tree = bfs_tree(g.graph, v; dir=:in)
    return Set(g.int_to_node[u] for u in vertices(tree) if u != v && has_vertex(tree, u) && (!isempty(inneighbors(tree, u)) || !isempty(outneighbors(tree, u))))
    # actually bfs_tree returns a graph of the same size, but only reached edges are present.
end

function ancestors(m::Model, node_id::NodeID)
    visited = Set{NodeID}()
    queue = [node_id]
    while !isempty(queue)
        current = popfirst!(queue)
        for cause in direct_causes(m, current)
            if !(cause in visited)
                push!(visited, cause)
                push!(queue, cause)
            end
        end
    end
    return visited
end

"""
    descendants
"""
function descendants(g::CauseEffectGraph, node_id::NodeID)
    v = g.node_to_int[node_id]
    tree = bfs_tree(g.graph, v; dir=:out)
    return Set(g.int_to_node[u] for u in vertices(tree) if u != v && (!isempty(inneighbors(tree, u)) || !isempty(outneighbors(tree, u))))
end

function descendants(m::Model, node_id::NodeID)
    visited = Set{NodeID}()
    queue = [node_id]
    while !isempty(queue)
        current = popfirst!(queue)
        for effect in direct_effects(m, current)
            if !(effect in visited)
                push!(visited, effect)
                push!(queue, effect)
            end
        end
    end
    return visited
end

"""
    root_causes
"""
function root_causes(g::CauseEffectGraph)
    return Set(g.int_to_node[v] for v in vertices(g.graph) if indegree(g.graph, v) == 0)
end

function root_causes(m::Model)
    roots = Set{NodeID}()
    for id in nodes_of(m)
        if isempty(direct_causes(m, id))
            push!(roots, id)
        end
    end
    return roots
end
export paths, has_cycles, is_valid

"""
    paths
"""
function paths(g::CauseEffectGraph, src::NodeID, dst::NodeID)
    u = g.node_to_int[src]
    v = g.node_to_int[dst]
    # Graphs.jl doesn't have all_paths, we use Yen's k-shortest paths or standard DFS
    # We can keep the DFS logic for all_paths
    all_paths = Vector{Vector{NodeID}}()
    function dfs(current::NodeID, current_path::Vector{NodeID})
        push!(current_path, current)
        if current == dst
            push!(all_paths, copy(current_path))
        else
            for effect in direct_effects(g, current)
                if !(effect in current_path)
                    dfs(effect, current_path)
                end
            end
        end
        pop!(current_path)
    end
    dfs(src, Vector{NodeID}())
    return all_paths
end

function paths(m::AbstractModel, src::NodeID, dst::NodeID)
    all_paths = Vector{Vector{NodeID}}()
    function dfs(current::NodeID, current_path::Vector{NodeID})
        push!(current_path, current)
        if current == dst
            push!(all_paths, copy(current_path))
        else
            for effect in direct_effects(m, current)
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

"""
    has_cycles
"""
function has_cycles(g::CauseEffectGraph)
    return Graphs.is_cyclic(g.graph)
end

function has_cycles(m::AbstractModel)
    visited = Set{NodeID}()
    rec_stack = Set{NodeID}()
    function is_cyclic(node::NodeID)
        if !(node in visited)
            push!(visited, node)
            push!(rec_stack, node)
            for effect in direct_effects(m, node)
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
    for id in nodes_of(m)
        if is_cyclic(id)
            return true
        end
    end
    return false
end

# Check if a model is valid
"""
    is_valid

Automatically generated docstring for `is_valid`.
"""
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
