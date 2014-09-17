class MapLoader
  class MapLoadError < StandardError
  end

  def self.error(message)
    raise MapLoadError, message
  end

  # Try to detect file type by extension
  def self.detect_format(filename)
    ext = File.extname filename
    case ext
    when ".json"
      MapFormat::Json
    when ".txt", ".amap"
      MapFormat::AsciiGraphics
    else
      nil
    end
  end

  attr_reader :filename, :detected_format

  def initialize(filename)
    @filename = filename
    @detected_format = self.class.detect_format(@filename)
  end
  
  def load(options = {})
    self.class.error("Unable to detect map file format for #{@filename}") unless @detected_format
    load_with_format(@detected_format, options = {})
  end

  def load_with_format(format, options = {})
    format.load(@filename, options)
  end
end
