module SolutionEncoder
  module Strings
    module_function

    # Newline-delimited list of actions
    def encode(serialized_actions = [])
      serialized_actions.join("\n")
    end
  end
end
