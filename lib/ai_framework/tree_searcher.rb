class TreeSearcher
  attr_reader :context

  def initialize(context)
    @context = context
  end

  def self.build_root_node(start_action, start_state)
    Node.new.tap do |node|
      node.payload[:state] = start_state
      node.payload[:action] = start_action
      node.payload[:depth] = 1
      node.payload[:path_cost] = 0
    end
  end

  def build_child_node(parent_node, action, state)
    parent_node.build_child_node.tap do |new_node|
      new_node.payload[:state] = state
      new_node.payload[:action] = action
      new_node.payload[:depth] = parent_node.payload[:depth] + 1
      new_node.payload[:path_cost] = parent_node.payload[:path_cost] + step_cost(parent_node, action, new_node)
    end
  end

  def search(fringe, root_node)
    fringe.insert! root_node
    loop do
      return nil if fringe.empty?
      node = fringe.take!
      return self.class.fetch_solution(node) if context.target_state == node.payload[:state]
      successors = expand(node)
      fringe.insert!(successors)
    end
    raise "Never should go here!"
  end

  def expand(node)
    successors = []
    enumerate_successors(node) do |action, result|
      successors << build_child_node(node, action, result)
    end
    successors
  end

  def step_cost(node_from, action, node_to)
    1
  end

  def enumerate_successors(node)
    result_positions = []
    context.allowed_actions.each do |action|
      next unless context.agent.action_desired?(node.payload[:state], action)
      new_state = node.payload[:state].act(action)
      yield [action, new_state]
    end
  end

  def self.fetch_solution(node)
    solution = [ node.payload[:action] ]
    solution.unshift(node.payload[:action]) while node = node.parent
    solution
  end
end
