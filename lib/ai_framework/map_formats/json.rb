require 'json'

module MapFormat
  module Json
    module_function

    def load(filename, options = {})
      load_from_json_string(File.read(filename))
    end

    def save(map, filename, options = {})
      write_to_file(hash_for_map(map), filename)
    end

  protected
    module_function

    # Do not expose those to the API!

    # Loading
    def load_from_json_string(json)
      load_from_hash(JSON.parse(json))
    end

    def load_from_hash(hash)
      raise "Unsupported map format version: #{hash['format_version']}" if hash['format_version'] != 1

      Map.new.tap do |map|
        map.obstacles = hash['map']['obstacles']
      end
    end

    # Saving
    def hash_for_map(map)
      {
        format_version: 1,
        type: :infinite_flat_map,
        map: {
          obstacles: map.obstacles.to_a
        }
      }
    end

    def write_to_file(hash, filename)
      File.open(filename, "w") do |f|
        f << ::JSON.pretty_generate(hash)
      end
    end
  end
end