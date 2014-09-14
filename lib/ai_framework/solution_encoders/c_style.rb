module SolutionEncoder
  module CStyle
    module_function

    # What if someone made a neat visualizer in C?
    def encode(serialized_actions = [])
      str = serialized_actions.size.to_s + "\n"
      str += serialized_actions.join("\n")
      str += "\n"
      str
    end
  end
end
