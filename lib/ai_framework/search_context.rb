require 'ai_framework/validateable_struct'

class SearchContext < ValidateableStruct
  # Any search context must have these defined.
  values :world, :agent, :target_state, :allowed_actions

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
end
