module GenectiAlgorithm

  importall Types

  function fitness(solution::Solution)
    fit = 0
    for i in 1:size(solution.grid)[1]
      for j in 1:size(solution.grid)[1]
        fit += size(find(x -> x == i, solution.grid[j,:]))[1] > 1 ? 1 : 0
        fit += size(find(x -> x == i, solution.grid[:,j]))[1] > 1 ? 1 : 0
      end
    end
    return fit
  end

  export fitness, Solution, Game

end
