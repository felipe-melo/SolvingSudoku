module GeneticAlgorithm

  importall Types

  #elit::Array{Solution}
  #immigrant::Array{Solution}

  function fitness(solution::Solution)
    fit = 0
    for i in 1:size(solution.grid)[1]
      for j in 1:size(solution.grid)[1]
        #Analise se existe o número i repetido na linha j
        fit += size(find(x -> x == i, solution.grid[j,:]))[1] > 1 ? 1 : 0
        #Analise se existe o número i repetido na coluna j
        fit += size(find(x -> x == i, solution.grid[:,j]))[1] > 1 ? 1 : 0
      end
    end
    return fit
  end

  function crossOver(sol1::Solution, sol2::Solution)

    offspring = Solution(copy(sol2.grid), sol1.order)

    fit1 = fitness(sol1)
    fit2 = fitness(sol2)

    for i in 1:sol1.order^2
      for j in 1:sol1.order^2
        if rand(1:fit1 + fit2) <= fit1
          offspring.grid[i, j] = sol1.grid[i, j]
        end
      end
    end

    return offspring
  end

  function runGenetic(game::Types.Game)
    sort!(game.solutions, by=fitness)
    bestSolution::Solution = game.solutions[1]

    while fitness(bestSolution) > 0
      s1, s2 = findPairs(game)
      sn = crossOver(s1, s2)
      game.solutions[end] = sn
      sort!(game.solutions, by=fitness)
      bestSolution = game.solutions[1]
      println(fitness(bestSolution))
    end
    return bestSolution
  end

  function findPairs(game::Types.Game)
    totalFitness = 0
    for s in game.solutions
      totalFitness += fitness(s)
    end

    indexSol = rand(0:1)

    sol1 = nothing
    sol2 = nothing

    for s in game.solutions
      fit = fitness(s)
      if 1 - fit / totalFitness > indexSol
        sol1 = s
        break
      end
      indexSol = indexSol - 1 - fit / totalFitness
    end

    indexSol = rand(0:1)

    for s in game.solutions
      fit = fitness(s)
      if 1 - fit / totalFitness > indexSol
        sol2 = s
        break
      end
      indexSol = indexSol - 1 - fit / totalFitness
    end

    return sol1, sol2

  end

  export runGenetic, Solution, Game

end
