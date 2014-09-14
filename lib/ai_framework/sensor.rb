class Sensor
  def initialize(storage = nil)
    @storage = storage
    @booted = false
  end

  def boot!(boot_data = {})
    @agent = boot_data[:agent]
    raise "No agent passed!" unless @agent
    @booted = true
  end

  def booted?
    @booted
  end

protected

  # Use this to validate value presence during the boot phase.
  # Rasies error with failure_message if key is not in hash.
  def validate_presence!(hash, key, failure_message)
    raise ArgumentError, failure_message unless hash.key?(key)
  end
end

class WorldSensor < Sensor
  def boot!(boot_data = {})
    super
    validate_presence! boot_data, :world, "No world passed!"
    @world = boot_data[:world]
  end
end

# This sensors is bound to a world and knows about the map and
# provides the information about the collision with the objects in the world.
# Use this to simulate real robot's collision sensor.
class WorldCollisionSensor < WorldSensor
  def has_obstacle_towards?(current_state, direction)
    # Get our position from the state
    position_to_check = current_state.position.shift(direction)

    # Check if we collide with the map
    @world.map.obstacles.member?(position_to_check.to_a)
  end
end

# This sensor is used to detect is we are at the target state.
# This can be used to trigger some final action to happen,
# in example to make a robot wave hand at target state.
class DesiredStateSensor < Sensor
  def boot!(boot_data = {})
    super
    validate_presence! boot_data, :target_state, "No target state defined!"
    @target_state = boot_data[:target_state]
  end

  def at_desired_state?(current_state)
    current_state == @target_state
  end
end

# This is a tricky one. This makes the agent memorize the states at which
# he already been to, and block actions that lead to te same states.
# Current implementation is bould to the PositionedState implementation
# via fetch_stuff_to_remember methor, but this may change in the future.
class AlreadyVisitedSensor < Sensor
  # True if we're going to go into a loop
  def loop?(current_state, direction)
    stuff_to_remember = fetch_stuff_to_remember(current_state, direction)

    # Check if we tried to go there before
    memory.member?(stuff_to_remember)
  end

  # Mark action as considered for the current state
  def mark_as_considered!(current_state, direction)
    stuff_to_remember = fetch_stuff_to_remember(current_state, direction)
    memory << stuff_to_remember
    true
  end

  # Ommit huge outputs with this neat trick
  def to_s
    super
  end

private

  # Warning! This is bound to PositionedState state and will crash if
  # used with other types of states.
  # Works for me. I know that's ugly, but I don't care now.
  # If you need a sensor like this for another agent, the best option
  # now is to make your own!
  def fetch_stuff_to_remember(current_state, direction)
    current_state.position.shift(direction).to_a
  end

  def memory
    @memory ||= Set.new
  end
end
