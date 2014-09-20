module Pathfinder
  class IterativeDeepeningSearch < DepthLimitedSearch
    def search(root_node, start_limit = 0)
      limit = start_limit
      loop do
        result = recursive_search(root_node, limit)
        return result if result != :cutoff
        puts "INFO: #{result.inspect} at #{limit}"
        limit += 1
      end
    end
  end
end
