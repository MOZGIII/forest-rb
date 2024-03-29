class SearchBase
  attr_reader :context

  def initialize(context)
    @context = context
  end

  # Builds root node with specified initial parameters.
  def self.build_root_node(start_action, start_state)
    Node.new.tap do |node|
      node.payload[:state] = start_state
      node.payload[:action] = start_action
      node.payload[:depth] = 0
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
    # reimplement me!
  end

  # Given a node, returns its successors, depending on context.
  def expand(node)
    successors = []
    enumerate_successors(node) do |action, result|
      successors << build_child_node(node, action, result)
    end
    successors
  end

  # Takes a tree search node and returns it's successors' action/state pairs.
  def enumerate_successors(node)
    result_positions = []
    context[:allowed_actions].each do |action|
      next unless context[:agent].action_desired?(node.payload[:state], action)
      new_state = node.payload[:state].act(action)
      next if state_exists_in_parents?(node, new_state) # disallow going backwards
      yield [action, new_state]
    end
  end

  # Used to check if we're going to reach already unwrapped state
  def state_exists_in_parents?(node, state)
    while node = node.parent
      return true if state == node.payload[:state]
    end
    false
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
