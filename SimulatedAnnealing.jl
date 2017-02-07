module SimulatedAnnealing

  importall Util

  function fitness(solution::Solution)
    fit = 0
    size = solution.order
    for i in 1:size
      #Analise se existe o número i repetido na linha j
      fit += size(find(y -> length(find(x-> x == y, solution.grid[i,:])) > 1, solution.grid[i,:]))[1]
    end
    for j in 1:size
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

    return std(temp_delta)
  end

  function neighborhoodWalk(solution::Solution, game::Game)
    new_solution = deepcopy(solution)
    possib_size = 0

    while (possib_size == 0)
      @show sorted_grid_colum, sorted_grid_line = rand(1:game.order), rand(1:game.order)

      line_end = sorted_grid_line * game.order
      colum_end = sorted_grid_colum * game.order
      line_start = line_end - game.order + 1
      colum_start = colum_end - game.order + 1
      sorted_grid = game.grid[line_start:line_end,colum_start:colum_end]

      possib_lines, possib_coluns, values = findnz(sorted_grid)
      possibs = [possib_lines possib_coluns]
      possibs_size = size(possibs)[0]
    end
    possibs_size > 0
    indexs = collect(1:possibs_size)
    @show first_index = rand(indexs)
    deleteat!(indexs, first_index)
    @show second_index = rand(indexs)

    @show new_solution[possibs[first_index, :]], new_solution[possibs[second_index, :]] = new_solution[possibs[second_index, :]], new_solution[possibs[first_index, :]]
    new_solution.fitness = fitness(new_solution)
    return new_solution
  end

  function runSimulatedAnnealing(game::Game, a::Float32 = 0.9, reheat_th::Int = 10000, max_num_of_interation::Int = 500000)

    ## Inicializa Variáveis
    t = zeros(Int, 0) #vetor de temperaturas com 0 elementos
    probality(delta) = exp(-(delta/t[end])) # função de probabilidade
    ml = length(findnz(game.grid))^2 # ml of Markov Chain = quantidade de valores não fixos ao quadrado
    ml_time = 0 # quantidade de Markov Chains percorridas = 0
    push!(t, initialTemperature(game, 100)) # inicializa solução inicial com a variação padrão de um quantidade pequena de vizinhanças
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
