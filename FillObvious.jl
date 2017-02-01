# include("Types.jl")
module FillObvious
  importall Types

  function fillObviousCells(game::Game)
    local fillered_some_thing = true
    local unsolved_cells = Inf
    while fillered_some_thing && unsolved_cells > 0
      updateFillingPossibilities(game)
      fillered_some_thing = fillValuesOnlyPossibleOneCell(game)
      fillered_some_thing = fillValuesWithOnePossibility(game) || fillered_some_thing
      unsolved_cells = getNumberOfBlankCells(game)
    end
  end

  function getNumberOfBlankCells(game::Game)
    zero_indexes = find(x -> x == 0, game.grid)
    return length(zero_indexes)
  end

  function fillValuesWithOnePossibility(game::Game)
    local grid_size = game.order*game.order
    local fillered = false;
    for i in 1:grid_size
      for j in 1:grid_size
        if game.grid[i,j] != 0
          continue
        end
        @show i, j
        @show possib_list = setdiff(game.possibilities[i,j,:],0)
        if length(possib_list) == 1
          fillered = true
          game.grid[i,j] = possib_list[1]
        end
      end
    end
    return fillered
  end

  function fillValuesOnlyPossibleOneCell(game::Game)
    local array_size = game.order*game.order
    local fillered = false
    possib = game.possibilities
    grid = game.grid

    for i in 1:array_size
      unique_indexs = find(y -> length(find(x-> x == y, possib[i,:,:])) == 1, possib[i,:,:])
      if length(unique_indexs) == 0
        continue
      end
      fillered = true
      colums = unique_indexs%array_size
      colums[find(x -> x== 0, colums)] = array_size
      @show i
      @show grid[i, colums] = possib[i, unique_indexs]
    end
    for i in 1:array_size
      unique_indexs = find(y -> length(find(x-> x == y, possib[:,i,:])) == 1, possib[:,i,:])
      if length(unique_indexs) == 0
        continue
      end
      fillered = true
      lines = unique_indexs%array_size
      lines[find(x -> x== 0, lines)] = array_size
      @show i
      @show grid[lines, i] = possib[:, i,:][unique_indexs]
    end
    for i in 1:array_size
      @show i
      line = i % game.order
      line = line == 0 ? game.order : line
      colum = Int(ceil(i / game.order))

      line_end = line * game.order
      colum_end = colum * game.order
      line_start = line_end - game.order + 1
      colum_start = colum_end - game.order + 1

      possib_sec = possib[line_start:line_end,colum_start:colum_end,:]
      unique_indexs = find(y -> length(find(x-> x == y,possib_sec)) == 1, possib_sec)
      if length(unique_indexs) == 0
        continue
      end
      fillered = true;
      offsets = unique_indexs%array_size
      offsets[find(x -> x== 0, offsets)] = array_size

      lines = offsets % game.order
      lines[find(x -> x== 0, lines)] = game.order
      colums = convert(Array{Int}, ceil(offsets / game.order))
      lines = lines + line_start -1
      colums = colums + colum_start - 1
      indexs = (colums-1)*array_size + lines
      @show grid[indexs] = possib_sec[unique_indexs]
    end

    game.grid = grid;
    return fillered
  end

  function updateFillingPossibilities(_game::Game)
    array_size = _game.order*_game.order
    grid = _game.grid
    possibilities = collect(Int, 1:array_size)
    fill_posib = zeros(Int, array_size, array_size, array_size)
    for j in 1:array_size
     for i in 1:array_size
        if grid[i,j] != 0
          continue
        end
        grid_line = Int(ceil(i/_game.order)*_game.order) - _game.order + 1
        grid_colum = Int(ceil(j/_game.order)*_game.order) - _game.order + 1
        grid_line_final = grid_line + _game.order - 1
        grid_colum_final = grid_colum + _game.order - 1
        # fill_posib[i,j] = possibilities
        aux = possibilities
        values = findnz(grid[grid_line:grid_line_final, grid_colum:grid_colum_final])[3]
        aux = setdiff(aux, values )
        values = findnz(grid[i:i, 1:_game.order*_game.order])[3]
        aux = setdiff(aux, values )
        values = findnz(grid[1:_game.order*_game.order, j:j])[3]
        aux = setdiff(aux, values )
        @show i, j
        @show fill_posib[i,j,:] = resize!(append!(aux, fill_posib[i,j,:]), array_size)
      end
    end
    _game.possibilities = fill_posib
    return fill_posib
  end

  export fillObviousCells, updateFillingPossibilities, fillValuesOnlyPossibleOneCell, fillValuesWithOnePossibility
end
