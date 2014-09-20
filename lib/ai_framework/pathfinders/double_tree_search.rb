module Pathfinder
  class DoubleTreeSearch < SearchBase
    # This is an unefficient implementetion of the idea behind
    # two-way search, but I still like it better than the other approaches.
    # The bad part here is that we use one fringe. By using two separate
    # fringes for each tree, we could decrease "mate" node search time.
    def search(fringe, start_root_node, stop_root_node)
      start_root_node.payload[:tree] = :start
      stop_root_node.payload[:tree] = :end
      fringe.insert!([start_root_node, stop_root_node])
      loop do
        return nil if fringe.empty?
        node = fringe.take! # now node is no longer in fringe!
        mate_node = get_mate_node(node, fringe)
        return self.class.fetch_solution_with_mate(node, mate_node) if mate_node
        successors = expand(node)
        fringe.insert!(successors)
      end
      raise "Never should go here!"
    end


    def get_mate_node(node, fringe)
      return nil if node.payload[:action].kind_of?(SpawnAction) # do not count spawn actions
      local_tree = node.payload[:tree]
      local_state = node.payload[:state]
      fringe.each do |other_node|
        next if local_tree == other_node.payload[:tree] # skip all nodes from the same tree
        return other_node if local_state == other_node.payload[:state]
      end
      nil
    end

    def self.fetch_solution_with_mate(start_tree_node, end_tree_node)
      start_tree_node, end_tree_node = end_tree_node, start_tree_node if start_tree_node.payload[:tree] == :end
      from_start = fetch_solution(start_tree_node)
      from_end = fetch_solution(end_tree_node)
      from_end.map! { |action| action.reversable? ? action.reversed : nil }.compact!.reverse!
      from_start + from_end
    end

    def build_child_node(parent_node, action, state)
      super.tap do |node|
        node.payload[:tree] = parent_node.payload[:tree]
      end
    end
  end
end
