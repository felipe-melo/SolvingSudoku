include("Types.jl")
include("Util.jl")
include("GeneticAlgorithm.jl")
include("FillObvious.jl")
include("CreateInstances.jl")
include("SimulatedAnnealing.jl")

using Types
using CreateInstances
using FillObvious
using SimulatedAnnealing
using Util


dificulty = parse(Int, ARGS[1])
i = parse(Int, ARGS[2])
quant = parse(Int, ARGS[3])

# dificulty = 3
# i = 1
# quant = convert(Int, 500)



# a = parse(Float64, ARGS[3])
# reheat_th = parse(Int, ARGS[4])
# max_num_of_interation = parse(Int, ARGS[5])

instances = Types.Instances(dificulty)
game = instances.instances[i]
println("$(dificulty) $(i) $(quant)")
fillObviousCells(game)

makeFirstSolution(game, quant)

solution = runGenetic(game)
