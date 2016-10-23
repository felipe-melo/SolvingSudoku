module CreateInstances

  #Obj que representa um tabuleiro
  type Game
    order::Int64
    grid
    staticValues
  end

  #Lê uma configuração do arquivo conforme os parâmetros de order
  #o parâmetro p significa a porcentagem de values que ficaram a mostra
  #retorna uma configuração de jogo já com os valores escondidos
  function readGame(order::Int64, p::Float64)
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
  function generateConfiguration(quant::Int64, order::Int64, p::Float64)
    grids = Array(Game, quant)
    for i in 1:quant
      grid = readGame(order, p)
      #Construtor do obj Game, o terceiro parâmetro
      #corresponde aos valores que serão imutáveis
      game = Game(order, grid, [])
      changeColumns(game)
      changeLines(game)
      grids[i] = game
    end
    return grids
  end

  #realiza a primeira solução dado uma configuração
  function makeFirstSolution(game::Game)
    order = game.order
    grid = game.grid
    #seta os valores imutáveis para a variável correta
    nozeros = find(x -> x != 0, grid)
    game.staticValues = nozeros
    for i in 1:order:order^2
      for j in 1:order:order^2
        iszeros = find(x -> x == 0, grid[i:i-1+order, j:j-1+order])
        values = setdiff(1:order^2, grid[i:i-1+order, j:j-1+order])
        grid[i:i-1+order, j:j-1+order] = map(x -> x = (x == 0 ? pop!(values) : x), grid[i:i-1+order, j:j-1+order])
      end
    end
  end

end

using CreateInstances

grids = CreateInstances.generateConfiguration(20, 3, 0.3)

for i in 1:20
  for j in 1:3^2
    println(grids[i].grid[j,:])
  end
  println()
  CreateInstances.makeFirstSolution(grids[i])
  for j in 1:3^2
    println(grids[i].grid[j,:])
  end
  println()
end
