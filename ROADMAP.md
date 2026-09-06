# ROADMAP for CausalGraphs.jl

This document outlines the phased development plan and an "agent harness" (a set of sequential tasks for an AI coding agent) to build the `CausalGraphs.jl` package according to the specification defined in `spec.md`.

## Phase 1: Core Architecture & Knowledge Graph (Fundamentals)
**Goal:** Implement the foundational data structures for the cause-effect knowledge graph, independent of any specific model or visualization.

- [x] **Project Setup:** Initialize the Julia package `CausalGraphs.jl` (if not already done). Set up `Project.toml`, `src/CausalGraphs.jl`, and `test/runtests.jl`.
- [x] **Type Definitions:**
  - Define `NodeID` (e.g., UUID-based or Integer-based stable identifier).
  - Define node types: `AbstractNode`, `EffectNode`, `CauseNode`, `IntermediateNode`, `CategoryNode`.
  - Define relationship/edge types: `causes`, `contributes_to`, `decomposes_into`, `depends_on`.
- [x] **Core Graph Structure:** Implement `CauseEffectGraph` struct. It should store nodes, directed edges, and metadata.
- [x] **Graph API:**
  - `add_effect!(g, label; metadata...)`
  - `add_cause!(g, category_or_node, label; metadata...)`
  - `add_category!(g, label; metadata...)`
  - `add_edge!(g, src, dst, relationship_type; metadata...)`
- [x] **Tests:** Write unit tests for graph creation, node identity stability, and metadata attachment.

## Phase 2: Modeling Layer
**Goal:** Implement the ability to derive specific models from the underlying knowledge graph.

- [x] **Model Structures:** Define `AbstractModel` and `Model` structs. A model references a base `CauseEffectGraph` and tracks a subset of its nodes/edges.
- [x] **Model API:**
  - `add_model!(g, id; metadata...)`
  - `add_to_model!(model, node_or_edge)`
- [x] **Model Composition & Abstraction:** Implement logic for submodels and alternative models for the same effect.
- [x] **Tests:** Validate that multiple models can coexist and use subsets of the knowledge graph without modifying the underlying graph.

## Phase 3: Graph Analysis & Validation
**Goal:** Implement traversal and analysis functions.

- [x] **Traversal API:**
  - `direct_causes(g, node)`, `direct_effects(g, node)`
  - `ancestors(g, node)`, `descendants(g, node)`
  - `paths(g, src, dst)`
  - `root_causes(g, subgraph)`
- [x] **Cycle Detection:** Optional check for DAG property when requested.
- [x] **Model Validation:** Check for unused causes or unsupported relationships within a model context.

## Phase 4: Metrology Domain Extension
**Goal:** Implement measurement models and prepare integration points for `SymbolicUncertainties.jl`.

- [x] **MeasurementModel:** Implement a specialized `MeasurementModel <: AbstractModel`.
- [x] **API Additions:**
  - Define input quantities and output quantity for the `MeasurementModel`.
  - API to associate nodes with symbolic variables or uncertainty budgets.
- [x] **Tests:** Recreate the GUM H.1 example structurally.

## Phase 5: Views and Serialization
**Goal:** Implement independent view extraction (Ishikawa, Tree) and I/O.

- [x] **Serialization:** Implement `write_json(g, path)` / `read_json(path)` or TOML to ensure stable identity round-tripping.
- [x] **View Structures:** Define intermediate structures for layouts (e.g., `IshikawaLayout`).
- [x] **GraphViz / Text Representation:** Output a text-based tree or DOT format as a baseline visualization backend.
- [x] **Tests:** Ensure serialization is deterministic and round-trips correctly.

---

## Agent Harness (Instructions for AI Agents)

To execute this roadmap autonomously using an agent, use the following ordered prompts. You can feed these one by one to your agent.

### Prompt 1: Project Setup and Core Types
> "Read `spec.md` (specifically sections 1-7). Initialize the `CausalGraphs.jl` package structure. In `src/core_types.jl`, define the core node types (`Effect`, `Cause`, `Intermediate`, `Category`), the relationship types, and the `CauseEffectGraph` struct to hold nodes, edges, and metadata. Use UUIDs or integers for stable `NodeID`s. Write basic tests in `test/runtests.jl`."

### Prompt 2: Core Graph API
> "Based on `spec.md` (Section 21), implement the mutating API for `CauseEffectGraph` in `src/graph_api.jl`: `add_effect!`, `add_cause!`, and `add_category!`. Ensure nodes can accept arbitrary metadata. Update tests to construct the initial parts of the GUM H.1 example."

### Prompt 3: Modeling Layer
> "Read `spec.md` (Sections 8-10). Implement the `Model` abstraction in `src/models.jl`. A `Model` should be able to select a subset of nodes and edges from a parent `CauseEffectGraph` and hold its own metadata/assumptions. Add functions to compare two models and extract a model's scope. Write corresponding tests."

### Prompt 4: Graph Analysis
> "Read `spec.md` (Section 17). In `src/analysis.jl`, implement graph traversal functions: `direct_causes`, `direct_effects`, `ancestors`, `descendants`, `root_causes`, and `paths`. Ensure these can operate on both the full `CauseEffectGraph` and a scoped `Model`. Write tests to verify traversals."

### Prompt 5: Metrology Extension
> "Read `spec.md` (Sections 11-13). Create `src/metrology.jl` defining `MeasurementModel`. Implement the traceability functions to map graph nodes to inputs/outputs (e.g., $Y = f(X)$). Write a test fully constructing the structural side of the GUM H.1 example."

### Prompt 6: Serialization
> "Read `spec.md` (Section 19). Implement serialization and deserialization for `CauseEffectGraph` and `Model` in `src/serialization.jl` using JSON or TOML. Write tests that serialize a populated graph, deserialize it, and verify that the structures and stable IDs match exactly (round-trip testing)."
