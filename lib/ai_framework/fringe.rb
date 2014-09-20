require 'set'

class Fringe
  def empty?
    true
  end

  def insert!(values)
    # not implemented here
  end

  def take!
    # not implemented here
  end
end

class FringeArrayBase < Fringe
  def initialize
    @array = []
  end

  def insert!(values)
    array.push(*Array(values))
  end

  def empty?
    @array.empty?
  end

protected

  def array
    @array
  end
end

class FringeFIFO < FringeArrayBase
  def take!
    array.shift
  end
end

class FringeLIFO < FringeArrayBase
  def take!
    array.pop
  end
end

class FringeSet < Fringe
  def initialize
    @set = Set.new
  end

  def empty?
    @set.empty?
  end

  def insert!(*args)
    array.push(*args)
  end

  def take!
    array.take
  end
end

class SearchableFringeFIFO < FringeFIFO
  def each(&block)
    array.each(&block)
  end
end
