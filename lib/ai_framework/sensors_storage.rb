class SensorsStorage
  def initialize(sensor_classes = [])
    @sensors_booted = false
    @sensors = {}

    build!(sensor_classes)
  end

  def build!(sensor_classes)
    sensor_classes.each do |sensor_class|
      @sensors[sensor_class] = sensor_class.new
    end
  end

  def get(class_name)
    @sensors[class_name]
  end

  def each
    @sensors.values.each do |sensor|
      yield sensor
    end
  end

  def to_hash
    @sensors.dup
  end

  def sensors_booted?
    @sensors_booted
  end

  def boot!(boot_data = {})
    raise "Sensors already booted!" if @sensors_booted
    @sensors_booted = true

    # Boot 'em up...
    self.each do |sensor|
      specific_boot_data = boot_data[sensor.class] || {}

      raise "Agent should not be set by user during sensors boot!" if specific_boot_data.has_key?(:agent)
      specific_boot_data[:agent] = self

      sensor.boot!(specific_boot_data)
    end
  end

end
