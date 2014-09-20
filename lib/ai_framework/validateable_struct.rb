class ValidateableStruct < Hash
  def self.validates(*new_validates)
    @validates ||= []
    @validates.concat(new_validates) if new_validates && !new_validates.empty?
    @validates
  end

  def initialize(params)
    super
    params.each do |key, value|
      self[key] = value
    end
    validate_presence!(*self.class.validates)
  end

protected

  def validate_presence!(*keys)
    keys.flatten.each do |key|
      raise ArgumentError, "You must specify #{key}!" unless self.key?(key)
    end
  end
end
