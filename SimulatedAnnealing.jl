module SimulatedAnnealing

  importall Util

  function fitness(solution::Solution)
    local fit = 0
    for i in 1:solution.order
      fit += size(find(y -> length(find(x-> x == y, solution.grid[i,:])) > 1, solution.grid[i,:]))[1]
    end
    for j in 1:solution.order
      #Analise se existe o número i repetido na coluna j
      fit += size(find(y -> length(find(x-> x == y, solution.grid[:,j])) > 1, solution.grid[:,j]))[1]
    end
    return fit
  end

  function initialTemperature(game::Game, num_of_samples::Int = 100)
    solution = deepcopy(game.solutions[1])
    temp_delta = zeros(Int, num_of_samples)

    for i in 1:num_of_samples
      prev_fit = solution.fitness
      solution = neighborhoodWalk(solution, game)
      after_fit = solution.fitness
      temp_delta[i] = abs(after_fit - prev_fit)
    end
    @show temp_delta
    @show return std(temp_delta)
  end

  function neighborhoodWalk(solution::Solution, game::Game)
    new_solution = deepcopy(solution)
    local possib_size = 0
    indexs = Int[]
    sorted_grid = Array{Int, Int}
    new_solution_sorted_grid = Array{Int, Int}
    line_end, colum_end, colum_start, line_start = 0,0,0,0
    while (possib_size < 2 )
      @show sorted_grid_line, sorted_grid_colum = rand(1:game.order), rand(1:game.order)
      line_end = sorted_grid_line * game.order
      colum_end = sorted_grid_colum * game.order
      line_start = line_end - game.order + 1
      colum_start = colum_end - game.order + 1
      sorted_grid = game.grid[line_start:line_end,colum_start:colum_end]
      new_solution_sorted_grid = new_solution.grid[line_start:line_end,colum_start:colum_end]

      indexs = find(x-> x==0, sorted_grid)
      possib_size = length(indexs)
    end
    shuffle!(indexs)
    first_index = pop!(indexs)
    second_index = pop!(indexs)
    println("Solução Velha")
    printSolution(solution)
    new_solution_sorted_grid[first_index], new_solution_sorted_grid[second_index] = new_solution_sorted_grid[second_index], new_solution_sorted_grid[first_index]
    new_solution.grid[line_start:line_end,colum_start:colum_end] = new_solution_sorted_grid
    new_solution.fitness = fitness(new_solution)
    println("Solução Nova")
    printSolution(new_solution)
    @show new_solution.fitness
    return new_solution
  end

  function runSimulatedAnnealing(game::Game, a::Float64 = 0.9, reheat_th::Int = 10000, max_num_of_interation::Int = 500000)

    ## Inicializa Variáveis
    t = zeros(0) #vetor de temperaturas com 0 elementos
    probality(delta) = exp(-(delta/t[end])) # função de probabilidade
    ml = length(findnz(game.grid))^2 # ml of Markov Chain = quantidade de valores não fixos ao quadrado
    @show ml
    ml_time = 0 # quantidade de Markov Chains percorridas = 0
    solution = game.solutions[1] # solução atual
    solution.fitness = fitness(solution)
    best_solution = game.solutions[1] # melhor solução

    t0 = initialTemperature(game, 100)
    @show t0
    push!(t, t0) # inicializa solução inicial com a variação padrão de um quantidade pequena de vizinhanças
    time = 0 # tempo = 0; numero de interações
    while solution.fitness > 0 && time < max_num_of_interation
      new_solution = neighborhoodWalk(solution, game) # produz nova solução
      @show new_solution.fitness
      @show solution.fitness
      @show delta = new_solution.fitness - solution.fitness # calcula a varuação do fitness
      if delta < 0 # verifica se o fitness melhorou
        best_solution = new_solution # atualiza melhor solução
        solution = new_solution # solução atual
      else # Se não melhorou
        @show prob = probality(abs(delta)) # calcula a probalidade de aceitação

        if rand() < prob # se aceitar
          @show solution.grid - new_solution.grid
          solution = new_solution # atualiza solução atual
        end
      end

      if time % ml == 0 # se percorri toda a Markov Chain
        @show time, ml,
        push!(t, a * t[end] ) # atualizo temperatura
        ml_time += 1
      end

      if ml_time == reheat_th ## se percorri todas as n cadeias e não achei a solução...
        @show ml_time, reheat_th
        push!(t, t[1]) # reseta temperatura para a temperatura inicial
        ml_time = 0 # reseta o contador de markov chains
      end
      time += 1;
      @show time
    end

    game.solutions[1] = best_solution
    @show game.solutions[1].fitness
    @show game.solutions[1].grid
  end

  export runSimulatedAnnealing, neighborhoodWalk
end
