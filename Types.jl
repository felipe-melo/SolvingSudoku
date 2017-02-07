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
    order::Int32
    grid::Array{Int32}
    possibilities::Array{Int}
    solutions::Array{Solution}

    function Game(order::Int32, grid::Array{Int32})
      new(order, grid)
    end
  end

  export Solution, Game

end
