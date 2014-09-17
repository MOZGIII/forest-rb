class ViewportCalculator
  def initialize(map)
    @map = map
  end

  def horizontal
    get_range_for(0)
  end

  def vertical
    get_range_for(1)
  end

  def width
    horizontal.size
  end

  def height
    vertical.size
  end

private

  def self.minmax_by(obstacles, index)
    obstacles.minmax do |a, b|
      a[index] <=> b[index]
    end
  end

  def get_range_for(index)
    a, b = self.class.minmax_by(@map.obstacles, index)
    return (0..0) unless a && b
    (a[index]..b[index])
  end
end
