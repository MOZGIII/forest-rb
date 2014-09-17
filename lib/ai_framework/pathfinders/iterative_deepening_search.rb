module Pathfinder
  class IterativeDeepeningSearch < DepthLimitedSearch
    def search(root_node)
      limit = 0
      loop do
        result = recursive_search(root_node, limit)
        p result, limit
        return result if result != :cutoff
        limit += 1
      end
    end
  end
end
