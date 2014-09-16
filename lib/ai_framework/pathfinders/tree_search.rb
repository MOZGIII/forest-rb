module Pathfinder
  class TreeSearch < SearchBase
    # Does the actual search.
    def search(fringe, root_node)
      fringe.insert! root_node
      loop do
        return nil if fringe.empty?
        node = fringe.take!
        return self.class.fetch_solution(node) if context.target_state?(node.payload[:state])
        successors = expand(node)
        fringe.insert!(successors)
      end
      raise "Never should go here!"
    end
  end
end
