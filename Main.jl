include("Types.jl")
include("GeneticAlgorithm.jl")
include("CreateInstances.jl")

importall CreateInstances

quant = convert(Int32, 20)
order = convert(Int32, 3)
p = convert(Float64, 0.3)

function main()
  game = generateConfiguration(quant, order, p)

  makeFirstSolution(game)

  runGenetic(game)

  #=for i in 1:game.order^2
    for j in 1:game.order^2
      print(convert(Int32, game.grid[i, j]), " ")
    end
    println()
  end

  println()

  for s in game.solutions
    printSolution(s)
  end=#

end

main()
