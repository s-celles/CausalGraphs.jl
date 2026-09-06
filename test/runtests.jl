using CausalGraphs
using Test

@testset "CausalGraphs.jl - Core and API" begin
    g = CauseEffectGraph()
    @test isempty(g.nodes)
    @test isempty(g.edges)

    # Recreate GUM H.1 structure
    l = add_effect!(g, "Gauge block length")
    @test haskey(g.nodes, l)

    instrument = add_category!(g, "Instrument")
    ls = add_cause!(g, instrument, "Reference length")
    D  = add_cause!(g, instrument, "Gauge block length difference")

    environment = add_category!(g, "Environment")
    theta = add_cause!(g, environment, "Temperature")

    @test length(g.nodes) == 6
    @test length(g.edges) == 3

    # Manually link categories to effect
    add_edge!(g, instrument, l, Causes())
    add_edge!(g, environment, l, Causes())

    @test length(g.edges) == 5
end

@testset "CausalGraphs.jl - Models" begin
    g = CauseEffectGraph()
    l = add_effect!(g, "Length")
    c1 = add_cause!(g, "Temperature")
    c2 = add_cause!(g, "Pressure")
    
    e1 = add_edge!(g, c1, l)
    e2 = add_edge!(g, c2, l)
    
    m1 = Model(g; metadata=Dict(:name => "Simple Model"))
    add_to_model!(m1, e1)
    
    @test length(m1.nodes) == 2
    @test length(m1.edges) == 1
    
    m2 = Model(g)
    add_to_model!(m2, e2)
    
    comp = compare_models(m1, m2)
    @test length(comp.nodes_only_in_m1) == 1
    @test length(comp.nodes_only_in_m2) == 1
    @test length(comp.edges_only_in_m1) == 1
    @test length(comp.edges_only_in_m2) == 1
end

@testset "CausalGraphs.jl - Analysis" begin
    g = CauseEffectGraph()
    l = add_effect!(g, "Length")
    c1 = add_cause!(g, "Temperature")
    c2 = add_cause!(g, "Pressure")
    c3 = add_cause!(g, c1, "Sunlight") # Sunlight -> Temperature
    
    add_edge!(g, c1, l)
    add_edge!(g, c2, l)
    
    @test length(direct_causes(g, l)) == 2
    @test length(direct_effects(g, c1)) == 1
    
    anc = ancestors(g, l)
    @test length(anc) == 3 # c1, c2, c3
    @test c3 in anc
    
    desc = descendants(g, c3)
    @test length(desc) == 2 # c1, l
    
    roots = root_causes(g)
    @test length(roots) == 2 # c3, c2
    @test c3 in roots
    @test c2 in roots
    @test !(c1 in roots)
end

@testset "CausalGraphs.jl - Metrology" begin
    g = CauseEffectGraph()
    l = add_effect!(g, "Gauge block length")
    
    instrument = add_category!(g, "Instrument")
    ls = add_cause!(g, instrument, "Reference length")
    D  = add_cause!(g, instrument, "Gauge block length difference")
    
    environment = add_category!(g, "Environment")
    theta = add_cause!(g, environment, "Temperature")
    
    add_edge!(g, ls, l)
    add_edge!(g, D, l)
    add_edge!(g, theta, l)
    
    m = MeasurementModel(g)
    set_output!(m, l)
    add_input!(m, ls)
    add_input!(m, D)
    add_input!(m, theta)
    
    @test m.output == l
    @test length(m.inputs) == 3
    @test ls in m.inputs
    @test length(m.nodes) == 4 # output + 3 inputs
end

@testset "CausalGraphs.jl - Serialization" begin
    g = CauseEffectGraph()
    add_effect!(g, "Effect")
    add_cause!(g, "Cause", metadata=Dict(:source => "Expert A"))
    
    path = tempname() * ".json"
    write_json(g, path)
    
    g2 = read_json(path)
    @test length(g2.nodes) == 2
    @test length(g2.edges) == 0
    
    # Check stable identity
    g_nodes = collect(values(g.nodes))
    g2_nodes = collect(values(g2.nodes))
    
    @test sort([n.id for n in g_nodes]) == sort([n.id for n in g2_nodes])
    @test sort([n.label for n in g_nodes]) == sort([n.label for n in g2_nodes])
    
    rm(path)
end

