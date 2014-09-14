module SolutionExporter
  module_function

  def export(actions, filename, encoder)
    File.open(filename, "w") do |f|
      serialized_actions = actions.map { |action| serialize_action(action) }
      f << encoder.encode(serialized_actions)
    end
  end

  def serialize_action(action)
    return action.serialize if action.respond_to?(:serialize)
    value = custom_serialize(action)
    raise "Unable to serialize action" unless value
    value
  end

  def custom_serialize(action)
    case action
    when MoveAction
      action.direction.name
    when SpawnAction
      "spawn"
    end
  end
end
