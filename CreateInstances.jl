include("Types.jl")
include("Util.jl")
include("GeneticAlgorithm.jl")

module CreateInstances

  importall GeneticAlgorithm

  #Lê uma configuração do arquivo conforme os parâmetros de order
  #o parâmetro p significa a porcentagem de values que ficaram a mostra
  #retorna uma configuração de jogo já com os valores escondidos
  function readGame(order::Int32, p::Float64)
    file = open("optimalInput/sudoku_$(order).dat")
    grid = readdlm(file)

    for i in 1:order^2
      grid[i,:] = map(x -> convert(Int32, (rand() > 1 - p)) * x, grid[i,:])
    end
    return convert(Array{Int32}, grid)
  end

  #realiza troca de colunas no range da ordem da matriz
  function changeColumns(game::Game)
    for i in 1:game.order
      k = rand(i * game.order - game.order + 1 : i * game.order)
      l = rand(i * game.order - game.order + 1 : i * game.order)
      aux = game.grid[:,k]
      game.grid[:,k] = game.grid[:,l]
      game.grid[:,l] = aux
    end
  end

  #realiza troca de linhas no range da ordem da matriz
  function changeLines(game::Game)
    for i in 1:game.order
      k = rand(i * game.order - game.order + 1 : i * game.order)
      l = rand(i * game.order - game.order + 1 : i * game.order)
      aux = game.grid[k,:]
      game.grid[k,:] = game.grid[l,:]
      game.grid[l,:] = aux
    end
  end

  #função principal desse module instancia um jogo a partir da ordem do mesmo
  function generateConfiguration(order::Int32, p::Float64)
    grid = readGame(order, p)
    #Construtor do obj Game, o primeiro parâmetro
    #corresponde a quantidade de soluções que serão geradas
    game = Game(order, grid)
    changeColumns(game)
    changeLines(game)
    return game
  end

  export generateConfiguration, makeFirstSolution, runGenetic, printSolution, findPairs, crossOver, fitness

end

importall CreateInstances

quant = convert(Int32, 500)
order = convert(Int32, 4)
p = convert(Float64, 0.3)

function main()
  game = generateConfiguration(order, p)

  makeFirstSolution(game, quant)

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

end

main()
