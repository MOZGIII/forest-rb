# Actions can be anything really,
# they does not define any meaningful
# interface
class Action
end

class MoveAction < Action
  attr_reader :direction

  def initialize(direction)
    @direction = direction
  end

  def to_s
    "Move #{direction.name}"
  end
end

class SpawnAction < Action
  def to_s
    "Spawned! \"Hello!\""
  end
end
