module Util

  importall Types

  #realiza a primeira solução dado uma configuração
  function makeFirstSolution(game::Game, quant::Int32)
    game.solutions = Array(Solution, quant)
    order = game.order
    for k in 1:quant
      grid = copy(game.grid)
      sol = Solution(grid, game.order)
      for i in 1:order:order^2
        for j in 1:order:order^2
          #Valores faltantes no quadrante
          values = setdiff(1:order^2, sol.grid[i:i-1+order, j:j-1+order])
          shuffle!(values)
          sol.grid[i:i-1+order, j:j-1+order] = map(x -> x = (x == 0 ? pop!(values) : x), sol.grid[i:i-1+order, j:j-1+order])
        end
      end
      game.solutions[k] = sol
    end
  end

  function printSolution(solution::Solution)
    for i in 1:solution.order^2
      for j in 1:solution.order^2
        print(solution.grid[i, j], " ")
      end
      println()
    end
    println()
  end

  function fillObvious!( game::Game)
    gameOrder
    
  end


  export Solution, Game, makeFirstSolution, printSolution

end
