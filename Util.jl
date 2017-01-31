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


  # function fillObviousCells(game::Game)
  #   fill_posib = updateFillingPossibilities(game);
  #
  # end
  #
  # function updateFillingPossibilities(_game::Game)
  #   array_size = _game.order*_game.order
  #   grid = _game.grid
  #   possibilities = collect(Int, 1:array_size)
  #   fill_posib = Array(Array, array_size, array_size)
  #   for j in 1:array_size
  #     for i in 1:array_size
  #       if grid[i,j] != 0
  #         fill_posib[i,j] = [0]
  #         continue
  #       end
  #       grid_line = Int(ceil(i/_game.order)*_game.order) - _game.order + 1
  #       grid_colum = Int(ceil(j/_game.order)*_game.order) - _game.order + 1
  #       grid_line_final = grid_line + _game.order - 1
  #       grid_colum_final = grid_colum + _game.order - 1
  #       fill_posib[i,j] = possibilities
  #       values = findnz(grid[grid_line:grid_line_final, grid_colum:grid_colum_final])[3]
  #       fill_posib[i,j] = setdiff(fill_posib[i,j], values )
  #       values = findnz(grid[i:i, 1:_game.order*_game.order])[3]
  #       fill_posib[i,j] = setdiff(fill_posib[i,j], values )
  #       values = findnz(grid[1:_game.order*_game.order, j:j])[3]
  #       fill_posib[i,j] = setdiff(fill_posib[i,j], values )
  #
  #     end
  #   end
  #   return fill_posib
  # end

  export Solution, Game, makeFirstSolution, printSolution


end
