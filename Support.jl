include("Types.jl")
include("Util.jl")
include("GeneticAlgorithm.jl")
include("CreateInstances.jl")
include("FillObvious.jl")
include("SimulatedAnnealing.jl")

importall CreateInstances
importall FillObvious
importall SimulatedAnnealing

order = convert(Int32, 3)
quant = convert(Int32, 1)
p = convert(Float64, 0.3)
game = generateConfiguration(order, p)
makeFirstSolution(game, quant)
