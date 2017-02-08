module SimulatedAnnealing

  importall Util

  function fitness(solution::Solution)
    local fit = 0
    for i in 1:solution.order
      @show fit += size(find(y -> length(find(x-> x == y, solution.grid[i,:])) > 1, solution.grid[i,:]))[1]
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

    @show return std(temp_delta)
  end

  function neighborhoodWalk(solution::Solution, game::Game)
    new_solution = deepcopy(solution)
    local possib_size = 0
    @show game
    indexs = Int[]
    sorted_grid = Array{Int, Int}
    line_end, colum_end, colum_start, line_start = 0,0,0,0
    while (possib_size < 2 )
      @show sorted_grid_line, sorted_grid_colum = rand(1:game.order), rand(1:game.order)

      line_end = sorted_grid_line * game.order
      colum_end = sorted_grid_colum * game.order
      line_start = line_end - game.order + 1
      colum_start = colum_end - game.order + 1
      sorted_grid = game.grid[line_start:line_end,colum_start:colum_end]

      @show indexs = find(x-> x==0, sorted_grid)
      possib_size = length(indexs)
    end
    shuffle!(indexs)
    first_index = pop!(indexs)
    second_index = pop!(indexs)
    @show sorted_grid[first_index], sorted_grid[second_index] = sorted_grid[second_index], sorted_grid[first_index]
    new_solution.grid[line_start:line_end,colum_start:colum_end] = sorted_grid
    @show new_solution.fitness = fitness(new_solution)
    return new_solution
  end

  function runSimulatedAnnealing(game::Game, a::Float64 = 0.9, reheat_th::Int = 10000, max_num_of_interation::Int = 500000)

    ## Inicializa Variáveis
    t = zeros(0) #vetor de temperaturas com 0 elementos
    probality(delta) = exp(-(delta/t[end])) # função de probabilidade
    ml = length(findnz(game.grid))^2 # ml of Markov Chain = quantidade de valores não fixos ao quadrado
    ml_time = 0 # quantidade de Markov Chains percorridas = 0
    @show t0 = initialTemperature(game, 100)
    push!(t, t0) # inicializa solução inicial com a variação padrão de um quantidade pequena de vizinhanças
    solution = game.solutions[1] # solução atual
    solution.fitness = fitness(solution)
    best_solution = game.solutions[1] # melhor solução
    time = 0 # tempo = 0; numero de interações

    while solution.fitness > 0 && time < max_num_of_interation
      @show new_solution = neighborhoodWalk(solution, game) # produz nova solução
      @show delta = new_solution.fitness - solution.fitness # calcula a varuação do fitness
      if delta > 0 # verifica se o fitness melhorou
        best_solution = new_solution # atualiza melhor solução
        solutions = new_solution # solução atual
      else # Se não melhorou
        @show prob = probality(delta) # calcula a probalidade de aceitação
        if rand() < prob # se aceitar
          @show solution = new_solution # atualiza solução atual
        end
      end

      if time % ml == 0 # se percorri toda a Markov Chain
        @show push!(t, a * t[end] ) # atualizo temperatura
        ml_time += 1
      end

      if ml_time == reheat_th ## se percorri todas as n cadeias e não achei a solução...
        @show push!(t, t[1]) # reseta temperatura para a temperatura inicial
        ml_time = 0 # reseta o contador de markov chains
      end
      @show time += 1;
    end

    @show game.solutions[1] = best_solution
  end

  export runSimulatedAnnealing, neighborhoodWalk
end
