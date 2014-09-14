require 'set'

class Map
  attr_reader :obstacles

  def self.demo
    self.new.tap do |map|
      map.obstacles = [
        [1, 1],
        [0, 1],
        [5, 6]
      ]
    end
  end

  # Creates an empty map
  def initialize
    @obstacles = Set.new
  end

  def obstacles=(value)
    value = Set.new(value) if value.kind_of?(Array)
    @obstacles = value
  end
end
