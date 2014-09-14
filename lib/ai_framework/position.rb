class Position
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def ==(other)
    self.x == other.x && self.y == other.y
  end

  def to_a
    [x, y]
  end

  def shift(direction, mode = :both)
    self.dup.tap{ |p| p.shift!(direction, mode) }
  end

  # Shift position to the direction specified
  def shift!(direction, mode = :both)
    case mode
    when :horizontal
      @x += direction.horizontal
    when :vertical
      @y += direction.vertical
    when :dual, :both
      @x += direction.horizontal
      @y += direction.vertical
    else
      raise "Invalid mode"
    end
  end
end
