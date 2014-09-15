class Action
  # Tells if this action is reversable or not.
  def reversable?
    false # reimplement this
  end

  # Returns the reverse action - the action that when performned
  # gives opposite result to the current action.
  def reversed
    nil # reimplement this
  end
end

class MoveAction < Action
  attr_reader :direction

  def initialize(direction)
    @direction = direction
  end

  def to_s
    "Move #{direction.name}"
  end

  # Any move action is reversable.
  def reversable?
    true
  end

  # Reverse action to move action is to move in the other direction.
  def reversed
    self.class.new(self.direction.opposite)
  end
end

class SpawnAction < Action
  def to_s
    "Spawned! \"Hello!\""
  end
end
