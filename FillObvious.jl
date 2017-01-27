include("Types.jl")
module FillObvious
  importall Types

  function fillObviousCells(game::Game)
    fill_posib = updateFillingPossibilities(game);
  end

  function updateFillingPossibilities(_game::Game)
    array_size = _game.order*_game.order
    grid = _game.grid
    possibilities = collect(Int, 1:array_size)
    fill_posib = Array(Array, array_size, array_size)
    for j in 1:array_size
      for i in 1:array_size
        if grid[i,j] != 0
          fill_posib[i,j] = [0]
          continue
        end
        grid_line = Int(ceil(i/_game.order)*_game.order) - _game.order + 1
        grid_colum = Int(ceil(j/_game.order)*_game.order) - _game.order + 1
        grid_line_final = grid_line + _game.order - 1
        grid_colum_final = grid_colum + _game.order - 1
        fill_posib[i,j] = possibilities
        values = findnz(grid[grid_line:grid_line_final, grid_colum:grid_colum_final])[3]
        fill_posib[i,j] = setdiff(fill_posib[i,j], values )
        values = findnz(grid[i:i, 1:_game.order*_game.order])[3]
        fill_posib[i,j] = setdiff(fill_posib[i,j], values )
        values = findnz(grid[1:_game.order*_game.order, j:j])[3]
        fill_posib[i,j] = setdiff(fill_posib[i,j], values )

      end
    end
    return fill_posib
  end

  export fillObviousCells, updateFillingPossibilities
end

include("CreateInstances.jl")
order = convert(Int32, 3)
p = convert(Float64, 0.3)
importall CreateInstances
importall FillObvious
game = generateConfiguration(order, p)
game
some = updateFillingPossibilities(game)
