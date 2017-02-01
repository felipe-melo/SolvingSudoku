include("Types.jl")
include("Util.jl")
include("GeneticAlgorithm.jl")
include("CreateInstances.jl")
include("FillObvious.jl")

importall CreateInstances
importall FillObvious

order = convert(Int32, 3)
quant = convert(Int32, 500)
p = convert(Float64, 0.3)
game = generateConfiguration(order, p)

fillObviousCells(game)













# fullValuesWithOnePossible

game.grid - grid1
