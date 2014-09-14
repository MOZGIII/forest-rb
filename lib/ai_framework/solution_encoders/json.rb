require 'json'

module SolutionEncoder
  module Json
    module_function

    # Standard JSON encoder, not much sense
    def encode(serialized_actions = [])
      JSON.pretty_generate({ actions: serialized_actions })
    end
  end
end