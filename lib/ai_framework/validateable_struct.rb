require 'ostruct'

class ValidateableStruct < OpenStruct
  def self.values(*new_values)
    @values ||= []
    @values.concat(new_values) if new_values && !new_values.empty?
    @values
  end

  def initialize(*args)
    super
    validate_presence!(*self.class.values)
  end

protected

  def validate_presence!(*keys)
    keys.flatten.each do |key|
      raise ArgumentError, "You must specify #{key}!" unless self.respond_to?(key)
    end
  end
end
