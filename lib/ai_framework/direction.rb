class Direction
  attr_reader :horizontal, :vertical

  def initialize(horizontal, vertical)
    validate_argument(horizontal)
    validate_argument(vertical)
    raise "Horizontal and vertical are both zeros!" if horizontal == 0 && vertical == 0
    @horizontal = horizontal.to_i
    @vertical = vertical.to_i
  end

  def horizontal_names
    @horizontal_names ||= {
      -1 => "left",
      0  => "stay",
      1  => "right",
    }
  end

  def vertical_names
    @vertical_names ||= {
      -1 => "up",
      0  => "stay",
      1  => "down",
    }
  end

  def horizontal_name
    horizontal_names[horizontal]
  end

  def vertical_name
    vertical_names[vertical]
  end

  def horizontal_part_direction
    self.class.new(horizontal, 0)
  end

  def vertical_part_direction
    self.class.new(0, vertical)
  end

  def inverted
    self.class.new(horizontal * -1, vertical * -1)
  end
  alias_method :opposite, :inverted

  # True is direction has horizontal component
  def horizontal?
    horizontal != 0
  end

  # True is direction has vertical component
  def vertical?
    vertical != 0
  end

  # True is direction has both horizontal and vertical component
  def diagonal?
    horizontal? && vertical?
  end

  def name
    @name ||= begin
      arr = []
      arr << horizontal_name if horizontal?
      arr << vertical_name   if vertical?
      arr.join("_")
    end
  end
  alias_method :to_s, :name  

  def id
    @id ||= shift_for_id(horizontal) * 10 + shift_for_id(vertical)
  end

private

  def validate_argument(value)
    raise "Invalid argument" if value != -1 && value != 0 && value != 1
  end

  def shift_for_id(value)
    validate_argument(value)
    value + 1 # -1 0 1 => 0 1 2
  end
end
