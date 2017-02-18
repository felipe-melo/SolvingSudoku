include("Types.jl")
include("Util.jl")
include("GeneticAlgorithm.jl")
include("CreateInstances.jl")
include("FillObvious.jl")

importall CreateInstances
importall FillObvious

quant = convert(Int32, 500)
order = convert(Int32, 3)
p = convert(Float64, 0.3)

game = generateConfiguration(order, p)
fillObviousCells(game)
makeFirstSolution(game, quant)

@show game.solutions

solution = runGenetic(game)

printSolution(solution)

println()

for i in 1:game.order^2
  for j in 1:game.order^2
    print(convert(Int32, game.grid[i, j]), " ")
  end
  println()
end

  #=println()

  for s in game.solutions
    printSolution(s)
  end=#






