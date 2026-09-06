# CausalGraphs.jl

[![CI](https://github.com/s-celles/CausalGraphs.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/s-celles/CausalGraphs.jl/actions/workflows/CI.yml)
[![Docs](https://github.com/s-celles/CausalGraphs.jl/actions/workflows/Docs.yml/badge.svg)](https://s-celles.github.io/CausalGraphs.jl/dev/)
[![Codecov](https://codecov.io/gh/s-celles/CausalGraphs.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/s-celles/CausalGraphs.jl)

`CausalGraphs.jl` is a Julia package for building, manipulating, and analyzing cause-effect knowledge graphs. It provides robust structures to manage cause/effect nodes, measurement models, and visual layouts like Ishikawa (fishbone) diagrams.

For comprehensive information, tutorials, and API reference, please refer to the [Documentation](https://s-celles.github.io/CausalGraphs.jl/dev/).

## Installation

```julia
using Pkg
Pkg.add("CausalGraphs")
```

For advanced visualization, you can also load `MakieCore` along with this package.
