class ViewportCalculator
  def initialize(map)
    @map = map
  end
  
  def horizontal
    a, b = minmax_by(0)
    return (0..0) unless a && b
    (a[0]..b[0])
  end

  def vertical
    a, b = minmax_by(1)
    return (0..0) unless a && b
    (a[1]..b[1])
  end

  def width
    horizontal.size
  end

  def height
    vertical.size
  end

private

  def minmax_by(index)
    @map.obstacles.minmax do |a, b|
      a[index] <=> b[index]
    end
  end
end