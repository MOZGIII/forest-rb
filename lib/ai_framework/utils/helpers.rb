module Utils
  module Helpers
    module_function

    def range_from_json(json)
      case json
      when NilClass
        nil
      when String
        Range.json_create(json)
      when Array
        raise ArgumentError, "Array size must equal 2!" if json.size != 2
        ( json[0].to_i .. json[1].to_i )
      else
        raise ArgumentError, "Cannot convert #{json} to Range!"
      end
    end

    def symbolize_keys(hash, recursive = true)
      new_hash = {}
      hash.each do |key, value|
        if recursive && value.kind_of?(Hash)
          new_hash[key.to_sym] = symbolize_keys(value, recursive)
        else
          new_hash[key.to_sym] = value
        end
      end
      new_hash
    end
  end
end
