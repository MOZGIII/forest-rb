require 'ostruct'

class SearchContext < OpenStruct
  def initialize(*args)
    super
    validate_presence!([
      :world,
      :agent,
      :target_state,     # this is here because we use it from both agent and searcher
      :allowed_actions,
    ])
  end

  # Verifies if the state passed is the target.
  def target_state?(some_state)
    some_state == target_state
  end

  # Takes a tree search node and returns it's successors' action/state pairs.
  def enumerate_successors(node)
    result_positions = []
    allowed_actions.each do |action|
      next unless agent.action_desired?(node.payload[:state], action)
      new_state = node.payload[:state].act(action)
      yield [action, new_state]
    end
  end

private

  def validate_presence!(*keys)
    keys.flatten.each do |key|
      raise ArgumentError, "You must specify #{key}!" unless self.respond_to?(key)
    end
  end
end
