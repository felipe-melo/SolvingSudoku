module SimulatedAnnealing

  importall Util

  function fitness(solution::Solution)
    local fit = 0
    for i in 1:solution.order^2
      fit += size(find(y -> length(find(x-> x == y, solution.grid[i,:])) > 1, solution.grid[i,:]))[1]
    end
    for j in 1:solution.order^2
      #Analise se existe o número i repetido na coluna j
      fit += size(find(y -> length(find(x-> x == y, solution.grid[:,j])) > 1, solution.grid[:,j]))[1]
    end
    return fit
  end

  function initialTemperature(game::Game, possibIndexs::Array{Array{Int}}, num_of_samples::Int = 100)
    solution = deepcopy(game.solutions[1])
    temp_delta = zeros(Int, num_of_samples)

    for i in 1:num_of_samples
      prev_fit = solution.fitness
      solution = neighborhoodWalk(solution, game, possibIndexs)
      after_fit = solution.fitness
      temp_delta[i] = after_fit - prev_fit
    end
    return std(temp_delta)
  end

  function neighborhoodWalk(solution::Solution, game::Game, possibIndexs::Array{Array{Int}})
    new_solution = deepcopy(solution)
    local possib_size = 0
    new_solution_sorted_grid = Array{Int, Int}
    indexs = Array{Int}
    line_end, colum_end, colum_start, line_start = 0,0,0,0
    while (possib_size < 2 )
      sorted_grid_line, sorted_grid_colum = rand(1:game.order), rand(1:game.order)
      line_end = sorted_grid_line * game.order
      colum_end = sorted_grid_colum * game.order
      line_start = line_end - game.order + 1
      colum_start = colum_end - game.order + 1

      new_solution_sorted_grid = new_solution.grid[line_start:line_end,colum_start:colum_end]

      indexs = copy(possibIndexs[sorted_grid_line, sorted_grid_colum])
      possib_size = length(indexs)
    end
    shuffle!(indexs)
    first_index = pop!(indexs)
    second_index = pop!(indexs)
    new_solution_sorted_grid[first_index], new_solution_sorted_grid[second_index] = new_solution_sorted_grid[second_index], new_solution_sorted_grid[first_index]
    new_solution.grid[line_start:line_end,colum_start:colum_end] = new_solution_sorted_grid
    new_solution.fitness = fitness(new_solution)
    return new_solution
  end

  function calcPossibIndexs(game::Game)
    possibIndexs = Array(Array{Int}, game.order, game.order)
    for j in 1:game.order
      for i in 1:game.order
        line_end = i * game.order
        colum_end = j * game.order
        line_start = line_end - game.order + 1
        colum_start = colum_end - game.order + 1
        atual_sub_matrix = game.grid[line_start:line_end,colum_start:colum_end]

        possibIndexs[i,j] = find(x-> x==0, atual_sub_matrix)
      end
    end
    return possibIndexs
  end
  function runSimulatedAnnealing(game::Game, a::Float64 = 0.9, reheat_th::Int = 1000, max_num_of_interation::Int = 500000)
    initial_timestamp =  Int(now())
    ## Inicializa Variáveis
    t = 0
    probality(delta) = exp(-(delta/t)) # função de probabilidade
    ml = length(find(x-> x==0, game.grid))^2 # ml of Markov Chain = quantidade de valores não fixos ao quadrado
    # println(ml)
    ml_time = 0 # quantidade de Markov Chains percorridas = 0
    solution = game.solutions[1] # solução atual
    solution.fitness = fitness(solution)
    # println(solution.grid)
    # println(solution.fitness)
    # println(game.grid)
    best_solution = game.solutions[1] # melhor solução
    time = 0 # tempo = 0; numero de interações
    timestamp = Int(now()) - initial_timestamp
    if solution.fitness > 0
      possibIndexs = calcPossibIndexs(game)
      t0 = initialTemperature(game, possibIndexs, 100)
      t = t0 # inicializa solução inicial com a variação padrão de um quantidade pequena de vizinhanças
      timestamp = Int(now()) - initial_timestamp
      while solution.fitness > 0 && time < max_num_of_interation
        new_solution = neighborhoodWalk(solution, game, possibIndexs) # produz nova solução
        delta = new_solution.fitness - solution.fitness # calcula a varuação do fitness
        if delta < 0 # verifica se o fitness melhorou
          best_solution = new_solution # atualiza melhor solução
          solution = new_solution # solução atual
        else # Se não melhorou
          prob = probality(abs(delta)) # calcula a probalidade de aceitação

          if rand() < prob # se aceitar
            solution.grid - new_solution.grid
            solution = new_solution # atualiza solução atual
          end
        end

        if time % ml == 0 # se percorri toda a Markov Chain
          ml_time += 1
          t = a * t # atualizo temperatura
        end

        if ml_time == reheat_th ## se percorri todas as n cadeias e não achei a solução...
          t = t0 # reseta temperatura para a temperatura inicial
          ml_time = 0 # reseta o contador de markov chains
        end
        time += 1;
        timestamp = Int(now()) - initial_timestamp
      end
    end
    timestamp = Int(now()) - initial_timestamp
    game.solutions[1] = best_solution
    return time, solution.fitness == 0
  end

  export runSimulatedAnnealing, neighborhoodWalk
end
