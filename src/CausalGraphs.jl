module CausalGraphs

# Core types
export NodeID, AbstractNode, EffectNode, CauseNode, IntermediateNode, CategoryNode
export RelationshipType, Causes, ContributesTo, DecomposesInto, DependsOn
export Edge, CauseEffectGraph

# Graph API
export nodes_of, edges_of, add_effect!, add_category!, add_intermediate!, add_cause!, add_edge!

# Models
export AbstractModel, Model, add_to_model!, compare_models

# Analysis
export direct_causes, direct_effects, ancestors, descendants, root_causes, paths, has_cycles, is_valid

# Metrology
export MeasurementModel, set_output!, add_input!

# Serialization
export write_json, read_json, to_dict, node_from_dict, rel_from_string, edge_from_dict

# Views
export print_tree, to_dot, to_mermaid, to_ishikawa, IshikawaLayout

include("core_types.jl")
include("graph_api.jl")
include("models.jl")
include("analysis.jl")
include("metrology.jl")
include("serialization.jl")
include("views.jl")

end # module
