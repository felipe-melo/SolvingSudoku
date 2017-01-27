include("CreateInstances.jl")
include("FillObvious.jl")
importall CreateInstances
importall FillObvious
order = convert(Int32, 3)
p = convert(Float64, 0.3)
game = generateConfiguration(order, p)
game
some = updateFillingPossibilities(game)


array_size = game.order*game.order
possibilities = collect(Int, 1:array_size)
fill_posib = Array(Array, array_size, array_size)
for j in 1:array_size
  for i in 1:array_size
    if grid[i,j] != 0
      fill_posib[i,j] = [0]
      continue
    end
    grid_line = Int(ceil(i/game.order)*game.order) - game.order + 1
    grid_colum = Int(ceil(j/game.order)*game.order) - game.order + 1
    grid_line_final = grid_line + game.order - 1
    grid_colum_final = grid_colum + game.order - 1
    fill_posib[i,j] = possibilities
    values = findnz(grid[grid_line:grid_line_final, grid_colum:grid_colum_final])[3]
    fill_posib[i,j] = setdiff(fill_posib[i,j], values )
    values = findnz(grid[i:i, 1:game.order*game.order])[3]
    fill_posib[i,j] = setdiff(fill_posib[i,j], values )
    values = findnz(grid[1:game.order*game.order, j:j])[3]
    fill_posib[i,j] = setdiff(fill_posib[i,j], values )

  end
end

fill_posib



test = zeros(2,2,2)
test[1,1, :] = [1 0]
test[1,1, findn(test[1,1,:])]

test2 = spzeros(2, 2)
test2[1,1] = [2 3]
