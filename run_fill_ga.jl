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

#dificulty = parse(Int, ARGS[1])
#i = parse(Int, ARGS[2])
p = parse(Float64, ARGS[1])
loopQuant = parse(Int, ARGS[2])
quant = parse(Int, ARGS[3])

#instances = Types.Instances(dificulty)
#game = instances.instances[i]

for i in 1:loopQuant
  game = generateConfiguration(3, p)

  #println("$(dificulty) $(i) $(quant)")
  fillObviousCells(game)

  makeFirstSolution(game, quant)

  count, solution = runGenetic(game)
  println("$p $count $(solution.fitness)")
end
