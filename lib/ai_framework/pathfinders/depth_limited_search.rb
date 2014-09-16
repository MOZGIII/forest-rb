module Pathfinder
  class DepthLimitedSearch < SearchBase
    def search(root_node, limit)
      value = recursive_search(root_node, limit)
      if value == :cutoff
        value = nil
        puts "INFO: depth limit exceeded!"
      end
      raise "Got #{value.inspect} in DLS as overall result!" if value.kind_of? Symbol # not good
      value
    end

    def recursive_search(node, limit)
      cutoff_occurred = false
      return self.class.fetch_solution(node) if context.target_state?(node.payload[:state])
      return :cutoff if node.payload[:depth] == limit

      expand(node).each do |successor|
        result = recursive_search(successor, limit)
        next unless result # failure case
        return result if result != :cutoff # success case, return asap
        cutoff_occurred = true # cutoff case, result == :cutoff
        raise "Result is not :cutoff!" unless result == :cutoff # sanity check
      end
      return :cutoff if cutoff_occurred
      nil # nil for failure
    end
  end
end
