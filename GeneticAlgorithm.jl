module GeneticAlgorithm

  importall Util

  function fitness(solution::Solution)
    local fit = 0
    for i in 1:solution.order^2
      #Analise se existe o número i repetido na coluna i
      fit += length(find(y -> length(find(x-> x == y, solution.grid[i,:])) > 1, solution.grid[i,:]))
    end
    for j in 1:solution.order^2
      #Analise se existe o número i repetido na coluna j
      fit += size(find(y -> length(find(x-> x == y, solution.grid[:,j])) > 1, solution.grid[:,j]))[1]
    end
    return fit
  end

  function crossOver(emptyPos::Array{Int}, sol1::Solution, sol2::Solution)
    offspring = Solution(copy(sol1.grid), sol1.order)

    order = sol1.order
    subVet = Array(Int, 0)

    for i in 1:order:order^2
      for j in 1:order:order^2
        subVet = offspring.grid[i:i-1+order, j:j-1+order]

        if rand() >= 0.75
          subVet = sol2.grid[i:i-1+order, j:j-1+order]
        end

        #Mutação
        if rand() >= 0.75 && length(emptyPos) > 2
          n1 = rand(emptyPos)
          n2 = rand(emptyPos)
          #println((n1, n2))
          aux = subVet[n1]
          subVet[n1] = subVet[n2]
          subVet[n2] = aux
        end
        offspring.grid[i:i-1+order, j:j-1+order] = subVet
      end
    end

    return offspring
  end

  function runGenetic(game::Game)
    initial_timestamp =  Int(now())

    totalFitness = 0

    for s in game.solutions
      s.fitness = fitness(s)
      totalFitness += s.fitness
    end

    fitnessCalc(sol) = sol.fitness

    sort!(game.solutions, by=fitnessCalc)

    bestSolution::Solution = game.solutions[1]

    count = 0

    newBestFit = 0
    lastBestFit = bestSolution.fitness

    timestamp = Int(now()) - initial_timestamp
    #println("$(timestamp) $(bestSolution.fitness)")

    emptyPos::Array{Int} = Array(Int, 0)
    order = game.order

    for i in 1:order:order^2
      for j in 1:order:order^2
        append!(emptyPos, find(x -> x == 0, game.grid[i:i-1+order, j:j-1+order]))
      end
    end

    times = Array(Int, 0)
    iterations = Array(Int, 0)

    while bestSolution.fitness > 0 && count < 5000000
      s1, s2 = findPairs(game, totalFitness) #Encontra par para crossOver
      offspring = crossOver(emptyPos, s1, s2) #Realiza crossOver dos escolhidos
      offspring.fitness = fitness(offspring)
      totalFitness += offspring.fitness #Add fitness do novo induviduo
      index = searchsortedfirst(game.solutions, offspring, by=fitnessCalc)
      insert!(game.solutions, index, offspring) #inseri novo elemento na ordem
      bestSolution = game.solutions[1]

      if (index == 1)
        lastBestFit = bestSolution.fitness
      end

      if (count % 1 == 0)
        newBestFit = bestSolution.fitness
      end
      count += 1

      if lastBestFit == newBestFit
        bestSolution, totalFitness = makeOthersSolutions(game)
        lastBestFit = bestSolution.fitness
        newBestFit = 0
      end
      timestamp = Int(now()) - initial_timestamp
      #println("$(count) $(timestamp) $(bestSolution.fitness) $(totalFitness)")
    end
    #Util.printSolution(bestSolution)
    return count, bestSolution
  end

  function makeOthersSolutions(game::Game)
    fitnessCalc(sol) = sol.fitness
    newGame = Game(game.order, game.grid)
    makeFirstSolution(newGame, convert(Int, round(length(game.solutions)*0.3+1)))
    #delete metado "ruim" das soluções
    deleteat!(game.solutions, collect(convert(Int, round(length(game.solutions)*0.3+1)):length(game.solutions)))

    for s in newGame.solutions
      s.fitness = fitness(s)
    end

    for s in newGame.solutions
      index = searchsortedfirst(game.solutions, s, by=fitnessCalc)
      insert!(game.solutions, index, s) #inseri novo elemento na ordem
    end

    totalFitness = 0

    for s in game.solutions
      totalFitness += s.fitness
    end

    bestSolution::Solution = game.solutions[1]

    return bestSolution, totalFitness
  end

  function findPairs(game::Game, totalFitness::Int)

    elitIndex = rand(1:convert(Int, round(length(game.solutions) * 0.3)))
    nonElitIndex = rand(convert(Int, round(length(game.solutions)*0.3+1)):length(game.solutions))

    return game.solutions[elitIndex], game.solutions[nonElitIndex]

  end

  export runGenetic, Solution, Game, makeFirstSolution, printSolution, fitness, findPairs, crossOver

end
