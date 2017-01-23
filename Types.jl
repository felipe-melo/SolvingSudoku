module Types

  #Obj que representa uma solução
  type Solution
    grid::Array{Int32}
    order::Int32
  end

  #Obj que representa uma configuração de um jogo
  type Game
    order::Int32
    grid::Array{Int32}
    solutions::Array{Solution}
    function Game(order::Int32, grid::Array{Int32})
      new(order, grid)
    end
  end

  export Solution, Game

end
