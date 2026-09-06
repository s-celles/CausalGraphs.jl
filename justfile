# Justfile for CausalGraphs.jl

default:
	@just --list

# Run tests
test:
	julia --project -e 'using Pkg; Pkg.test()'

# Build documentation
docs:
	julia --project=docs docs/make.jl
