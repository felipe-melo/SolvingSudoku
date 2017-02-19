module Types

  #Obj que representa uma solução
  type Solution
    grid::Array{Int32}
    order::Int32
    fitness::Int
    function Solution(_grid, _order)
      new(_grid, _order)
    end
  end

  #Obj que representa uma configuração de um jogo
  type Game
    order::Int
    grid::Array{Int}
    solution::Array{Int}
    possibilities::Array{Int}
    solutions::Array{Solution}

    function Game(order::Int, grid::Array{Int})
      new(order, grid)
    end
    function Game(order::Int, grid::Array{Int}, solution::Array{Int})
      new(order, grid, solution)
    end
  end

  type Instances
    instances::Array{Game}
    function Instances(mode::Int)
      dificulty = mode - 1 + 10
      file_a = open("Instances/s$(dificulty)a.txt")
      file_b = open("Instances/s$(dificulty)b.txt")
      file_c = open("Instances/s$(dificulty)c.txt")
      grid_a = convert(Array{Int}, readdlm(file_a))
      grid_b = convert(Array{Int}, readdlm(file_b))
      grid_c = convert(Array{Int}, readdlm(file_c))
      if dificulty == 13
        game_a = Game(4, grid_a)
        game_b = Game(4, grid_b)
        game_c = Game(4, grid_c)
      else
        game_a = Game(3, grid_a)
        game_b = Game(3, grid_b)
        game_c = Game(3, grid_c)
      end
      instances::Array{Game} = [game_a game_b game_c]
      new(instances)
    end
  end

  export Solution, Game

end
