```@raw html
---
layout: home

hero:
  name: CausalGraphs.jl
  image:
    src: assets/logo.svg
    alt: CausalGraphs.jl logo
  text: A Julia-native framework for representing, analyzing, composing, comparing, and visualizing cause-effect knowledge and models.
  tagline: Domain-independent causal relationships.
  actions:
    - theme: brand
      text: Get Started
      link: /
features:
  - icon: 🧠
    title: Cause-Effect Knowledge
    details: Build structured graphs independent from models and views.
  - icon: 📦
    title: Multiple Models
    details: Derive models from a single knowledge base without duplication.
  - icon: 🔬
    title: Metrology Support
    details: First-class integration with uncertainty propagation workflows.
---
```

# Introduction

**CausalGraphs.jl** is a Julia library for rigorously modeling, analyzing, and visualizing cause-and-effect relationships.

Unlike simple drawing tools, `CausalGraphs.jl` strictly separates **knowledge** (the relationship graph) from **views** (Ishikawa diagrams, dependency graphs) and **models** (measurement models, uncertainty propagation, fault trees).

### Common Use Cases
- **Metrology and Uncertainty** : Map uncertainty sources in a measurement model (e.g., Ishikawa / GUM) to automatically generate mathematical propagation models.
- **Systems Engineering and Reliability** : Model Fault Trees to identify the root causes of complex problems.
- **Incident Analysis (Root Cause Analysis)** : Formally record "what caused what" to capture knowledge following an IT or industrial failure.

---

# Visual Examples (Cause-Effect Trees)

Thanks to its decoupled architecture, the same knowledge graph can be exported in visual formats.

## Example 1: Metrology (Mass Calibration)
Here is how to build a typical cause-and-effect tree for weighing uncertainty. 

```@example ishikawa
using CausalGraphs
using Markdown

struct MermaidDisplay
    content::String
end

Base.show(io::IO, ::MIME"text/html", m::MermaidDisplay) = print(io, """
<div class="mermaid">
$(m.content)
</div>
""")

# 1. Create the graph
g = CauseEffectGraph()

# 2. Add the main effect (the problem or measurement)
effect = add_effect!(g, "Weighing Uncertainty")

# 3. Add categories (the "5Ms")
mat = add_category!(g, "Material")
env = add_category!(g, "Environment")
eqp = add_category!(g, "Equipment")
man = add_category!(g, "Manpower")
meth = add_category!(g, "Method")

# 4. Link the effect to categories
add_edge!(g, mat, effect)
add_edge!(g, env, effect)
add_edge!(g, eqp, effect)
add_edge!(g, man, effect)
add_edge!(g, meth, effect)

# 5. Add root causes
add_cause!(g, env, "Air temperature")
add_cause!(g, env, "Buoyancy")
add_cause!(g, eqp, "Balance drift")
add_cause!(g, eqp, "Resolution")
add_cause!(g, mat, "Density")
add_cause!(g, man, "Parallax error")
add_cause!(g, meth, "Calibration procedure")

# 6. Automatic visual rendering via Mermaid
MermaidDisplay(to_ishikawa(g))
```

## Example 2: Software Engineering (Server Crash)

Let's model an investigation following a server crash in a web infrastructure.

```@example ishikawa2
using CausalGraphs
using Markdown

g_it = CauseEffectGraph()

crash = add_effect!(g_it, "Website Downtime")

db = add_category!(g_it, "Database")
net = add_category!(g_it, "Network")
code = add_category!(g_it, "Application Code")

add_edge!(g_it, db, crash)
add_edge!(g_it, net, crash)
add_edge!(g_it, code, crash)

add_cause!(g_it, db, "CPU Saturation (Locks)")
add_cause!(g_it, db, "Disk Full")
add_cause!(g_it, net, "DDoS Attack")
add_cause!(g_it, net, "TLS Certificate Expiration")
add_cause!(g_it, code, "Memory Leak (OOM)")
add_cause!(g_it, code, "Faulty Deployment")

# Visual rendering
# We can reuse the MermaidDisplay struct defined above, but we have to define it again because Documenter @example blocks are isolated by default unless named the same or using a shared setup. 
# Wait, let's redefine it just to be safe.
struct MermaidDisplay
    content::String
end

Base.show(io::IO, ::MIME"text/html", m::MermaidDisplay) = print(io, """
<div class="mermaid">
$(m.content)
</div>
""")

MermaidDisplay(to_mermaid(g_it))
```

---

# API Reference

```@autodocs
Modules = [CausalGraphs]
```
