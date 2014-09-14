class State
  attr_reader :agent

  def initialize(agent)
    @agent = agent
  end

  def act(action)
    new_state = self.dup
    new_state.after_state_fork!
    new_state.act!(action)
    new_state
  end

  def after_state_fork!
    # not implemented here
  end

  def act!(action)
    # not implemented here
  end

  def ==(other)
    super
    # Reimplement this!
  end
end

class PositionedState < State
  attr_reader :position

  def initialize(agent, position)
    super(agent)
    @position = position
  end

  def after_state_fork!
    @position = @position.dup
  end

  def act!(action)
    case action
    when MoveAction
      position.shift!(action.direction)
    end
  end

  def ==(other)
    self.position == other.position
  end
end
