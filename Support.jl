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

dificulty = convert(Int,ARGS[1])
i = convert(Float64, ARGS[2])
a = convert(Float64, ARGS[3])
reheat_th = convert(Float64, ARGS[4])
max_num_of_interation = convert(Float64, ARGS[5])

instances = Types.Instances(dificulty)
game = instances.instances[i]
println("$(dificulty) $(i) $(a) $(reheat_th) $(max_num_of_interation)")
makeFirstSolution(game, 1)
runSimulatedAnnealing(game, a, reheat_th, max_num_of_interation)


# time = now()
# time2 = now()
# convert(Int, time2 - time)
# Millisecond(time)









##
