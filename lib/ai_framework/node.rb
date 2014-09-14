require 'ostruct'

class Node
  attr_reader :parent
  attr_reader :payload

  def initialize(parent = nil)
    @parent = parent
    @payload = OpenStruct.new # we don't need more than that
  end

  def root?
    !!parent
  end
  alias_method :detached?, :root?

  def build_child_node
    self.class.new(self)
  end

  def detach
    @parent = nil
  end

  def attach(node)
    raise "Invlid argumnet" if !node
    @parent = node
  end

  def self.root
    self.new
  end
end
