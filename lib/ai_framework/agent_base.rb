class AgentBase
  attr_reader :sensors

  def self.sensor_classes
    []
  end

  def initialize
    # Init sensors storage here
    @sensors = SensorsStorage.new(self.class.sensor_classes)
  end

  def action_desired?(current_state, action)
    # Implement this method in subclasses
  end
end
