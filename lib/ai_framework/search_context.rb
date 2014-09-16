require 'ai_framework/validateable_struct'

class SearchContext < ValidateableStruct
  # Any search context must have these defined.
  values :world, :agent, :target_state, :allowed_actions

  # Verifies if the state passed is the target.
  def target_state?(some_state)
    some_state == target_state
  end
end
