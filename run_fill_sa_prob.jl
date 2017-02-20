include("Types.jl")
include("Util.jl")
include("GeneticAlgorithm.jl")
include("FillObvious.jl")
include("CreateInstances.jl")
include("SimulatedAnnealing.jl")

using Types
using CreateInstances
using FillObvious
using SimulatedAnnealing
using Util
using Stats

a = 0.9
reheat_th = 50
max_num_of_interation = 2000000

p = collect(0.0:0.1:0.9)
csvfile = open("Results/output.csv","w")
println(pwd())
for p in 0.00:0.1:0.9
  println(p)
  p_results_interacoes = Array(Int, 0)
  p_results_solved = Array(Bool, 0)
  for i in 1:10
    println(i)
    order = convert(Int, 3)
    p = convert(Float64, p)
    game = generateConfiguration(order, p)
    fillObviousCells(game)
    makeFirstSolution(game, 1)
    interacoes, solved = runSimulatedAnnealing(game, a, reheat_th, max_num_of_interation)
    append!(p_results_interacoes, interacoes)
    append!(p_results_solved, solved)
  end

  write(csvfile, "$(p) $(mean(p_results_interacoes)) $(counts(p_results_solved, true)/length(p_results_solved)[1])\n")
end
close(csvfile)
#









##
