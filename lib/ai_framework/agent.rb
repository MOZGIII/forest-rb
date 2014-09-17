require 'ai_framework/agent_base'

class Agent < AgentBase
  def self.sensor_classes
    [
      WorldCollisionSensor,    # this is what makes things work
      # AlreadyVisitedSensor,  # optional, makes searches not overlap
      # DesiredStateSensor,    # can be used to hang actor at the desired state
    ]
  end

  def action_desired?(current_state, action)
    # If we reached our goal, we do not have any actions to do anymore!
    dss = sensors.get(DesiredStateSensor)  # this sensor might not exist
    return false if dss && dss.at_desired_state?(current_state)

    case action
    when MoveAction
      # Never go to where we've already been
      # This should be the last check!
      avs = sensors.get(AlreadyVisitedSensor)  # this sensor might not exist
      return false if avs && avs.loop?(current_state, action.direction)

      # Check for both axis
      return false if sensors.get(WorldCollisionSensor).has_obstacle_towards?(current_state, action.direction)

      # Can't walk through two adjacent walls
      if action.direction.diagonal?
        hblock = sensors.get(WorldCollisionSensor).has_obstacle_towards?(current_state, action.direction.horizontal_part_direction)
        vblock = sensors.get(WorldCollisionSensor).has_obstacle_towards?(current_state, action.direction.vertical_part_direction)
        return false if hblock && vblock
      end

      # Oh, we can go there!
      # Check that we considered moving from that state to that direction
      avs.mark_as_considered!(current_state, action.direction) if avs
      return true
    else
      STDERR.puts "WARNING: Unknown action #{action.class.name}!"
      return false
    end
    raise "We should never be in this code brach!"
  end
end
