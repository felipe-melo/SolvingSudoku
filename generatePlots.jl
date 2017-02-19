using Plots
using PyPlot

times = Array(Int, 0)
iterations = Array(Int, 0)
values = Array(Float64, 0)

file = open("Results/ga_fill_3_1_1")
results = readdlm(file)

lTime = 0
lIte = 0

for i in 3:100:size(results)[1]-2
  append!(iterations, results[i,1])
  append!(times, results[i,2])
  append!(values, rand())
  lTime = results[i,2]
  lIte = results[i,1]
end

#=pyplot()
plot!(title = "Algoritmo Genético", xlabel = "Tempo (ms)", ylabel = "Iterações")
plot!(xlims = (0, lTime), ylims = (0, lIte), xticks = times, yticks = iterations)
plot!(values)=#
