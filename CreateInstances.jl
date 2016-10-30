module CreateInstances

  #Obj que representa uma solução
  type Solution
    grid::Array{Int32}
    order::Int32
    fitness -> print(order)
    function Solution(grid::Array{Int32}, order::Int32)
      new(grid, order)
    end
    #=  fit = 0
      for i in 1:order
        fit += size(find(x -> x == i, grid[i,:]))[0] > 1 ? 1 : 0
        fit += size(find(x -> x == i, grid[:,i]))[0] > 1 ? 1 : 0
      end
      return fit
    end=#
  end

  #Obj que representa um tabuleiro
  type Game
    order::Int32
    grid::Array{Int32}
    quant::Int32
    solutions::Array{Solution}
    function Game(order::Int32, grid::Array{Float64}, quant::Int32)
      new(order, grid, quant)
    end
  end

  #Lê uma configuração do arquivo conforme os parâmetros de order
  #o parâmetro p significa a porcentagem de values que ficaram a mostra
  #retorna uma configuração de jogo já com os valores escondidos
  function readGame(order::Int32, p::Float64)
    file = open("optimalInput/sudoku_$(order)x$(order).dat")
    grid = readdlm(file)

    for i in 1:order^2
      grid[i,:] = map(x -> convert(Int32, (rand() > 1 - p)) * x, grid[i,:])
    end
    return grid
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

  #função principal desse module instancia vários jogos a partir da ordem do mesmo
  function generateConfiguration(quant::Int32, order::Int32, p::Float64)
    #grids = Array(Game, quant)
    grid = readGame(order, p)
    #Construtor do obj Game, o terceiro parâmetro
    #corresponde aos valores que serão imutáveis
    game = Game(order, grid, quant)
    changeColumns(game)
    changeLines(game)
    return game
  end

  #realiza a primeira solução dado uma configuração
  function makeFirstSolution(game::Game)
    game.solutions = Array(Solution, game.quant)
    order = game.order
    for k in 1:game.quant
      grid = copy(game.grid)
      sol = Solution(grid, game.order)
      for i in 1:order:order^2
        for j in 1:order:order^2
          #posições que são zero
          iszeros = find(x -> x == 0, sol.grid[i:i-1+order, j:j-1+order])
          #Valores faltantes no quadrante
          values = setdiff(1:order^2, sol.grid[i:i-1+order, j:j-1+order])
          shuffle!(values)
          sol.grid[i:i-1+order, j:j-1+order] = map(x -> x = (x == 0 ? pop!(values) : x), sol.grid[i:i-1+order, j:j-1+order])
        end
      end
      game.solutions[k] = sol
    end
  end
end

using CreateInstances

quant = convert(Int32, 20)
order = convert(Int32, 3)
p = convert(Float64, 0.3)

game = CreateInstances.generateConfiguration(quant, order, p)

for j in 1:3^2
  println(game.grid[j,:])
end
println()
CreateInstances.makeFirstSolution(game)
for i in 1:20
  for j in 1:3^2
    println(game.solutions[i].grid[j,:])
  end
  #println(game.solutions[i].fitness)
  println()
end
