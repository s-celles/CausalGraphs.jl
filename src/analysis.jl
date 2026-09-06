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
