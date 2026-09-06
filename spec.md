# CausalGraphs.jl — EARS Specification

## 1. Purpose

### 1.1 Objective

`CausalGraphs.jl` shall provide a Julia-native framework for representing, analyzing, composing, comparing, and visualizing **cause-effect knowledge and models**.

The package shall distinguish between:

1. a domain-level **cause-effect knowledge graph**;
2. one or more **models** derived from that knowledge;
3. domain-specific interpretations of those models;
4. visual representations such as Ishikawa diagrams, graphs, trees, and tables.

The framework shall remain domain-independent.

Potential applications shall include:

* quality analysis;
* metrology;
* measurement model development;
* uncertainty analysis;
* engineering;
* reliability;
* safety;
* troubleshooting;
* root-cause analysis;
* process analysis;
* risk analysis;
* scientific modeling.

### 1.2 Core principle

The package shall treat an **Ishikawa diagram as a view of a cause-effect model**, rather than as the fundamental data structure.

The package shall not assume that all cause-effect relationships are statistical causal relationships.

---

# 2. Conceptual Model

The package shall provide the following conceptual layers:

```text
                         Knowledge
                            │
                            ▼
                   CauseEffectGraph
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
           Model A        Model B        Model C
              │             │             │
              ▼             ▼             ▼
       Domain interpretation / analysis
              │
      ┌───────┼────────┬─────────┐
      ▼       ▼        ▼         ▼
   Ishikawa  Graph    Tree     Table
```

A cause-effect graph shall represent domain knowledge independently from any particular model.

A model shall define a particular interpretation, selection, abstraction, or mathematical representation of part of that knowledge.

---

# 3. Terminology

The following terms shall have precise meanings.

### 3.1 Effect

A node representing a phenomenon, outcome, result, property, state, or quantity being explained.

### 3.2 Cause

A node representing a factor that may influence another node.

### 3.3 Intermediate

A node representing an intermediate phenomenon between causes and effects.

### 3.4 Category

A logical grouping of causes.

Categories shall not have predefined semantics.

### 3.5 Cause-effect relationship

A directed relationship indicating that one entity contributes to, influences, produces, modifies, or explains another entity.

### 3.6 Knowledge graph

The domain-level graph containing potentially relevant causes, effects, relationships, hypotheses, and contextual information.

### 3.7 Model

A defined subset and/or interpretation of the knowledge graph used for a particular purpose.

### 3.8 Measurement model

A model in which a measurand or output quantity is expressed as a function of input quantities.

For example:

$$
Y=f(X_1,\ldots,X_n)
$$

### 3.9 View

A representation of an underlying graph or model that does not alter its semantics.

---

# 4. Functional Requirements

## 4.1 Cause-Effect Knowledge Graph

### CG-001 — Graph Creation

The system shall allow users to create an empty cause-effect graph.

### CG-002 — Stable Node Identity

Each node shall have a unique stable identifier independent of its display label.

### CG-003 — Node Types

The system shall support at least:

* Effect;
* Cause;
* Intermediate;
* Category.

### CG-004 — Arbitrary Metadata

The system shall allow arbitrary metadata to be associated with nodes.

Metadata may include:

* description;
* source;
* author;
* status;
* references;
* tags;
* domain-specific attributes.

### CG-005 — Directed Relationships

The system shall support directed relationships between nodes.

### CG-006 — Relationship Metadata

Relationships shall support arbitrary metadata.

### CG-007 — Relationship Types

The system shall support multiple relationship semantics, including at least:

* `causes`;
* `contributes_to`;
* `decomposes_into`;
* `depends_on`.

The architecture shall permit external packages to define additional relationship types.

---

# 5. Hierarchy and Decomposition

### CG-010 — Hierarchical Decomposition

The system shall support hierarchical decomposition of an effect into contributing causes.

### CG-011 — Semantic Independence

The semantic hierarchy shall be independent from any particular visualization.

### CG-012 — Nested Decomposition

A cause shall itself be decomposable into more detailed causes.

### CG-013 — Arbitrary Depth

The system shall support arbitrary decomposition depth.

### CG-014 — Shared Causes

A cause shall be allowed to contribute to multiple effects.

### CG-015 — DAG Support

The underlying representation shall support directed acyclic graphs rather than requiring a tree.

### CG-016 — Cycle Handling

When a model is declared acyclic, the system shall detect cycles and report them.

The core shall not otherwise prohibit cyclic graphs.

---

# 6. Categories

### CG-020 — User-Defined Categories

The system shall allow users to define arbitrary categories.

### CG-021 — No Mandatory Taxonomy

The system shall not require the traditional `5M` Ishikawa categories.

### CG-022 — Nested Categories

Categories shall optionally contain subcategories.

### CG-023 — Category Semantics

Categories shall be organizational constructs and shall not automatically imply causal semantics.

---

# 7. Evidence and Epistemic Status

### CG-030 — Evidence Status

Nodes and relationships shall optionally support an epistemic status.

The default vocabulary shall include:

* `unknown`;
* `hypothesis`;
* `possible`;
* `likely`;
* `confirmed`;
* `rejected`.

### CG-031 — Evidence References

Nodes and relationships shall optionally reference supporting evidence.

### CG-032 — Evidence Independence

Evidence metadata shall not automatically modify graph topology.

### CG-033 — Uncertainty of Knowledge

The system shall distinguish uncertainty about whether a relationship exists from quantitative uncertainty associated with a modeled quantity.

---

# 8. Models

## 8.1 Multiple Models

### CG-040 — Multiple Models

The system shall allow multiple models to coexist within the same knowledge graph.

### CG-041 — Model Identity

Each model shall have a unique stable identifier.

### CG-042 — Model Scope

A model shall identify the nodes and relationships from the knowledge graph that it uses.

### CG-043 — Model-Specific Relationships

A relationship may be valid in one model and absent from another.

### CG-044 — Model-Specific Assumptions

A model shall support explicit assumptions.

Examples include:

* linearity;
* negligible effects;
* independence;
* constant temperature;
* steady state;
* small-angle approximation.

### CG-045 — Model Metadata

Models shall support arbitrary metadata including:

* purpose;
* author;
* version;
* validity domain;
* assumptions;
* references;
* applicability conditions.

---

# 9. Model Composition

### CG-050 — Model Composition

The system shall allow models to be composed from reusable submodels.

### CG-051 — Shared Submodels

Multiple models shall be able to reference the same submodel.

### CG-052 — Model Reuse

A model shall be reusable in another model without duplicating its underlying entities.

### CG-053 — Model Expansion

The system shall allow a high-level model to be expanded into its underlying submodels.

### CG-054 — Model Abstraction

The system shall allow a detailed model to be represented through a higher-level abstraction.

---

# 10. Model Variants

### CG-060 — Alternative Models

The system shall allow multiple alternative models to represent the same effect.

For example:

```text
                    Measurand Y
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
          Model A                Model B
       simplified              detailed
```

### CG-061 — Model Comparison

The system shall allow two or more models to be compared.

Comparison may include:

* inputs;
* dependencies;
* assumptions;
* equations;
* included causes;
* excluded causes;
* model complexity.

### CG-062 — Model Traceability

The system shall identify which knowledge-graph entities are represented by each model.

### CG-063 — Model Difference

The system shall allow users to identify causes or relationships present in one model but absent from another.

---

# 11. Measurement Models

Measurement functionality shall be provided as an optional domain extension.

### MET-001 — Measurement Model

A measurement model shall represent:

$$
Y=f(X_1,\ldots,X_n)
$$

### MET-002 — Input Quantities

A measurement model shall identify its input quantities.

### MET-003 — Output Quantity

A measurement model shall identify its output quantity.

### MET-004 — Traceability

Each measurement-model quantity may be associated with one or more entities in the cause-effect knowledge graph.

### MET-005 — Model Assumptions

A measurement model shall support explicit assumptions relevant to its validity.

### MET-006 — Multiple Measurement Models

The same measurand shall be allowed to have multiple alternative measurement models.

### MET-007 — Model Selection

A model shall be selectable independently of the underlying knowledge graph.

---

# 12. Metrology Integration with SymbolicUncertainties.jl

### MET-010 — Optional Integration

The core package shall not depend on `SymbolicUncertainties.jl`.

### MET-011 — Symbolic Quantities

A measurement-model node may reference a symbolic quantity managed by an external symbolic system.

### MET-012 — Uncertainty Association

A measurement-model quantity may be associated with an uncertainty model.

### MET-013 — Sensitivity Traceability

The integration shall allow sensitivity coefficients to be associated with graph relationships.

For:

$$
Y=f(X)
$$

the relationship between \(X_i\) and \(Y\) may carry:

$$
c_i=\frac{\partial f}{\partial X_i}
$$

### MET-014 — Uncertainty Contributions

The integration shall allow uncertainty contributions to be associated with the corresponding graph entities.

### MET-015 — Uncertainty Budget Traceability

An uncertainty budget shall be traceable back to the corresponding cause-effect entities.

### MET-016 — Correlation Independence

A shared cause-effect relationship shall not automatically imply statistical correlation.

Statistical correlation shall be represented explicitly.

---

# 13. GUM-Oriented Workflow

The metrology extension should support the following workflow:

```text
Measurement principle
        │
        ▼
Cause-effect analysis
        │
        ▼
Identification of relevant quantities
        │
        ▼
Measurement model
        │
        ▼
Input quantity evaluation
        │
        ├── uncertainty
        ├── distribution
        ├── degrees of freedom
        └── correlations
        │
        ▼
Sensitivity analysis
        │
        ▼
Uncertainty budget
        │
        ▼
Measurement result
```

The package shall preserve traceability between these stages.

---

# 14. Ishikawa View

### VIEW-001 — Ishikawa Representation

The system shall provide an Ishikawa/fishbone view of a selected effect.

### VIEW-002 — Model-Based Ishikawa

An Ishikawa view shall be constructible from either:

* the complete knowledge graph;
* a selected model;
* a selected subgraph.

### VIEW-003 — Single Effect

The user shall be able to select the effect represented at the head of the fishbone.

### VIEW-004 — Category Mapping

The user shall be able to map arbitrary graph categories to Ishikawa branches.

### VIEW-005 — Automatic Categories

The system may infer categories when sufficient metadata is available.

### VIEW-006 — Shared Causes

Shared causes shall not be silently duplicated in the underlying model.

The visualization may display them in a manner appropriate to the selected layout.

### VIEW-007 — Semantic Preservation

Changing from an Ishikawa view to another view shall not alter the underlying graph or model.

---

# 15. Other Views

### VIEW-010 — Graph View

The system shall provide a generic directed-graph representation.

### VIEW-011 — Tree View

The system shall provide a hierarchical tree representation when the selected subgraph permits one.

### VIEW-012 — Dependency View

The system shall provide a dependency-oriented representation showing how selected quantities depend on other quantities.

### VIEW-013 — Table View

The system shall provide a tabular representation of selected nodes and relationships.

### VIEW-014 — Model View

The system shall provide a representation showing which entities belong to a selected model.

### VIEW-015 — Uncertainty View

The metrology integration may provide a view combining:

* input quantities;
* sensitivity coefficients;
* standard uncertainties;
* contributions;
* correlations.

---

# 16. View Independence

### VIEW-020 — Semantic/View Separation

The semantic model shall be independent from visualization.

### VIEW-021 — Layout Independence

Changing layout shall not modify graph semantics.

### VIEW-022 — Deterministic Rendering

Given the same graph, model, and layout configuration, rendering shall produce deterministic output whenever the selected backend supports deterministic rendering.

### VIEW-023 — Headless Rendering

Views shall support headless generation for:

* documentation;
* CI;
* automated reports;
* notebooks;
* AI agents.

### VIEW-024 — Vector Output

Visualization backends should support vector formats such as SVG.

---

# 17. Graph Analysis

### ANA-001 — Direct Causes

The system shall provide direct causes of a node.

### ANA-002 — Direct Effects

The system shall provide direct effects of a node.

### ANA-003 — Ancestors

The system shall provide all upstream ancestors of a node.

### ANA-004 — Descendants

The system shall provide all downstream descendants of a node.

### ANA-005 — Paths

The system shall provide paths between selected nodes.

### ANA-006 — Terminal Causes

The system shall identify terminal causes within a selected model or subgraph.

### ANA-007 — Root Causes

The system shall identify nodes with no upstream causes within a selected subgraph.

### ANA-008 — Subgraph Extraction

The system shall allow extraction of a model or subgraph around a selected effect.

---

# 18. Model Validation

### VAL-001 — Missing Inputs

A measurement model shall report required quantities that have no associated source or evaluation.

### VAL-002 — Unused Causes

The system shall be able to identify knowledge-graph causes that are not represented in a selected model.

### VAL-003 — Unsupported Relationships

The system shall report relationships required by a model but absent from the knowledge graph.

### VAL-004 — Assumption Validation

The system shall expose the assumptions under which a model is considered valid.

### VAL-005 — Model Completeness

The system should provide mechanisms for assessing whether relevant causes identified by the knowledge graph have been considered by the selected model.

---

# 19. Serialization

### SER-001 — Serialization

Graphs and models shall be serializable.

### SER-002 — Stable Identity

Serialization shall preserve stable node, relationship, model, and submodel identifiers.

### SER-003 — Human-Readable Format

The package shall support at least one human-readable serialization format.

Candidate formats include:

* TOML;
* JSON;
* YAML.

### SER-004 — Round Trip

Serializing and deserializing a graph shall preserve its semantics.

### SER-005 — Versioning

Serialized models shall contain sufficient information to support schema evolution.

---

# 20. Interoperability

### INT-001 — Graphs.jl

The package shall provide interoperability with `Graphs.jl`.

The core shall not necessarily require `Graphs.jl` as a mandatory dependency.

### INT-002 — Symbolics.jl

The metrology extension shall support interoperability with `Symbolics.jl`.

### INT-003 — SymbolicUncertainties.jl

The package shall provide an optional integration layer with `SymbolicUncertainties.jl`.

### INT-004 — Visualization Backends

The visualization API shall be independent of any single plotting backend.

Possible implementations may include:

* Makie;
* GraphViz;
* SVG generation;
* other Julia visualization ecosystems.

---

# 21. API Design

A possible API shall follow this conceptual structure:

```julia
using CausalGraphs

g = CauseEffectGraph()

l = add_effect!(g, "Gauge block length")

instrument = add_category!(g, "Instrument")
ls = add_cause!(g, instrument, "Reference length")
D  = add_cause!(g, instrument, "Gauge block length")

environment = add_category!(g, "Environment")
θ = add_cause!(g, environment, "Temperature")
```

A model may then be defined:

```julia
model = MeasurementModel(
    g,
    output = l,
    inputs = [ls, D, θ],
    ...
)
```

Multiple models may coexist:

```julia
simple = add_model!(g, ...)
gum_h1 = add_model!(g, ...)
detailed = add_model!(g, ...)
```

Views may then operate on the graph or a selected model:

```julia
ishikawa(g, l)
ishikawa(gum_h1)

graph(gum_h1)
tree(gum_h1)
table(gum_h1)
```

---

# 22. Example: GUM H.1

The following model:

```julia
@variables ls D δα θ α δθ

l =
    ls +
    D +
    ls * (δα * θ + α * δθ)
```

shall be representable as a measurement model:

$$
l=f(l_s,D,\delta\alpha,\theta,\alpha,\delta\theta)
$$

The corresponding knowledge graph may contain additional causes not included in this particular model.

For example:

```text
                         Gauge block length
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
          Instrument       Environment         Material
              │                 │                 │
          ┌───┴───┐             │             ┌───┴───┐
          │       │             │             │       │
         ls       D             θ             α      δα
                                │
                              δθ
```

The selected GUM model may then choose:

```text
ls
D
δα
θ
α
δθ
```

while another model could use a different set of quantities.

---

# 23. Traceability

### TRACE-001 — Cause-to-Model Traceability

The system shall allow users to determine whether a cause is represented in a selected model.

### TRACE-002 — Model-to-Cause Traceability

The system shall allow users to identify the originating cause-effect entities of each model quantity.

### TRACE-003 — Model-to-Result Traceability

The system shall allow a result to be traced through intermediate quantities to contributing causes.

### TRACE-004 — Uncertainty Traceability

In metrology applications, an uncertainty contribution shall be traceable to:

```text
cause
  ↓
input quantity
  ↓
measurement model
  ↓
sensitivity coefficient
  ↓
uncertainty contribution
  ↓
measurement result
```

---

# 24. Important Semantic Constraints

### SEM-001 — Cause Does Not Imply Correlation

A cause-effect relationship shall never automatically imply statistical correlation.

### SEM-002 — Category Does Not Imply Causality

Membership in a category shall not imply a causal relationship.

### SEM-003 — Visualization Does Not Define Semantics

An Ishikawa layout shall not define the meaning of the underlying graph.

### SEM-004 — Model Selection Does Not Delete Knowledge

Removing an entity from a model shall not remove it from the underlying knowledge graph.

### SEM-005 — Model Assumptions Are Explicit

Simplifications shall be represented as model assumptions rather than silently modifying the knowledge graph.

### SEM-006 — Domain Neutrality

The core package shall not assume that a relationship represents:

* physical causality;
* statistical causality;
* probability;
* uncertainty;
* risk;
* severity.

Such semantics shall be provided by domain extensions.

---

# 25. Non-Functional Requirements

### NFR-001 — Julia Native

The package shall follow idiomatic Julia design and multiple dispatch.

### NFR-002 — Composability

The package shall compose naturally with existing Julia packages.

### NFR-003 — Domain Independence

The core shall remain independent of metrology, quality, safety, and statistical inference.

### NFR-004 — Lightweight Core

The core dependency set should remain minimal.

### NFR-005 — Backend Independence

Visualization backends shall be optional.

### NFR-006 — Headless Operation

Core graph construction and analysis shall work without a graphical environment.

### NFR-007 — Reproducibility

Graphs and models shall be reproducible from serialized definitions.

### NFR-008 — AI Compatibility

The graph and model representation shall be machine-readable and suitable for automated manipulation by software agents.

---

# 26. Architectural Principle

The fundamental abstraction shall be:

> **A structured cause-effect knowledge graph from which multiple models and views can be derived.**

The architecture shall therefore follow:

```text
                         CauseEffectGraph
                                │
             ┌──────────────────┼──────────────────┐
             │                  │                  │
             ▼                  ▼                  ▼
        Knowledge          Model A            Model B
             │                  │                  │
             │                  └──────┬───────────┘
             │                         │
             ▼                         ▼
        Ishikawa                  Domain analysis
        Graph                     ├── Metrology
        Tree                      ├── Quality
        Table                     ├── Safety
                                  └── Reliability
```

For metrology:

```text
CauseEffectGraph
       │
       ▼
MeasurementModel
       │
       ▼
SymbolicUncertainties.jl
       │
       ├── sensitivity
       ├── uncertainty contributions
       ├── correlations
       ├── uncertainty budget
       └── GUM analysis
```

### Central design decision

**`CausalGraphs.jl` should describe the structure of knowledge.
`SymbolicUncertainties.jl` should perform the mathematical/metrological analysis of a selected measurement model.**

This separation allows one knowledge graph to support **several competing, simplified, detailed, or alternative measurement models** without duplicating the underlying causal knowledge.

