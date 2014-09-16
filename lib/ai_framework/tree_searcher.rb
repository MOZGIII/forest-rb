class TreeSearcher
  attr_reader :context

  def initialize(context)
    @context = context
  end

  # Builds root node with specified initial parameters.
  def self.build_root_node(start_action, start_state)
    Node.new.tap do |node|
      node.payload[:state] = start_state
      node.payload[:action] = start_action
      node.payload[:depth] = 1
      node.payload[:path_cost] = 0
    end
  end

  # Builds child node with specified action and state
  # Calculates depth and cost internally.
  # Note path cost comutation occurs after depth calculation and not like proposed.
  def build_child_node(parent_node, action, state)
    parent_node.build_child_node.tap do |new_node|
      new_node.payload[:state] = state
      new_node.payload[:action] = action
      new_node.payload[:depth] = parent_node.payload[:depth] + 1
      new_node.payload[:path_cost] = parent_node.payload[:path_cost] + step_cost(parent_node, action, new_node)
    end
  end

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

  # Given a node, returns its successors, depending on context.
  def expand(node)
    successors = []
    context.enumerate_successors(node) do |action, result|
      successors << build_child_node(node, action, result)
    end
    successors
  end

  # Step cost for the simplest case.
  def step_cost(node_from, action, node_to)
    1
  end

  # Fetch solutions by going directly up a tree.
  def self.fetch_solution(node)
    solution = [ node.payload[:action] ]
    solution.unshift(node.payload[:action]) while node = node.parent
    solution
  end
end
