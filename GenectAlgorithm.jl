module GenectiAlgorithm

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

  function crossOver(sol1::Solution, sol2::Solution, static::Array{Int32})
    offspring = copy(static)

    for i in 1:size(sol1)[1]
      for j in 1:size(sol1)[1]
        if offspring[i,j] != 0
          if rand([1, 2]) == 1
            offspring[i, j] = sol1[i, j]
          else
            offspring[i, j] = sol2[i, j]
          end
        end
      end
    end

    return offspring
  end

  function runGenect(game::Game)
    #ordena soluções pelo fitness (tem que melhorar)
    for i in 1:game.quant
      for j in i+1:game.quant
        if fitness(game.solutions[i]) > fitness(game.solutions[j])
          sol = game.solutions[i]
          game.solutions[i] = game.solutions[j]
          game.solutions[j] = sol
        end
      end
    end
  end

  export runGenect, Solution, Game

end
