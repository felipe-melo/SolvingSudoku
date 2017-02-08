include("Types.jl")
include("Util.jl")
include("GeneticAlgorithm.jl")
include("CreateInstances.jl")
include("FillObvious.jl")
include("SimulatedAnnealing.jl")

using Types
using CreateInstances
using FillObvious
using SimulatedAnnealing
using Util
using Iterators

order = convert(Int32, 4)
quant = convert(Int32, 1)
p = convert(Float64, 0.3)
game = generateConfiguration(order, p)
makeFirstSolution(game, quant)
runSimulatedAnnealing(game)

println("SOLUÇÃO")
print(game.solutions[1])




function fitness(solution::Solution)
  local fit = 0
  for i in 1:solution.order
    fit += size(find(y -> length(find(x-> x == y, solution.grid[i,:])) > 1, solution.grid[i,:]))[1]
  end
  for j in 1:solution.order
    #Analise se existe o número i repetido na coluna j
    fit += size(find(y -> length(find(x-> x == y, solution.grid[:,j])) > 1, solution.grid[:,j]))[1]
  end
  return fit
end
