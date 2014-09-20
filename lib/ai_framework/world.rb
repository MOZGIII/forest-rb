class World
  attr_reader :map

  # World only has a map in it.
  def initialize(map)
    @map = map
  end

  def inspect
    to_s
  end
end
