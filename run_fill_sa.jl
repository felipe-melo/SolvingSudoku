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
a = parse(Float64, ARGS[3])
reheat_th = parse(Int, ARGS[4])
max_num_of_interation = parse(Int, ARGS[5])

# a, reheat_th, max_num_of_interation = 0.98, 1000, 500000
# dificulty = 1

instances = Types.Instances(dificulty)
game = instances.instances[i]
println("$(dificulty) $(i) $(a) $(reheat_th) $(max_num_of_interation)")
fillObviousCells(game)
makeFirstSolution(game, 1)
runSimulatedAnnealing(game, a, reheat_th, max_num_of_interation)

# time = now()
# time2 = now()
# convert(Int, time2 - time)
# Millisecond(time)









##
