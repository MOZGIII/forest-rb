require 'json'

module MapFormat
  module AsciiGraphics
    module_function

    def load(filename, options = {})
      from_ascii_graphics(File.read(filename), options)
    end

    def save(map, filename, options = {})
      data = to_ascii_graphics(map, options)
      File.open(filename, "w") do |f|
        f << data
      end
    end

    def from_ascii_graphics(data, options = {})
      options[:obstacle_symbols] ||= /[^\. ]/
      options[:offset] ||= [0, 0]

      map = Map.new

      data.split("\n").each_with_index do |line, y|
        next if line.empty?
        line.split('').each_with_index do |letter, x|
          map.obstacles << [x + options[:offset][0], y + options[:offset][1]] if letter =~ options[:obstacle_symbols]
        end
      end

      map
    end

    def to_ascii_graphics(map, options = {})
      options[:horizontal_viewport] ||= (0...10)
      options[:vertical_viewport]   ||= (0...10)

      options[:symbol_for_empty]    ||= '.'
      options[:symbol_for_obstacle] ||= '#'

      buffer = ""
      options[:horizontal_viewport].each do |y|
        options[:vertical_viewport].each do |x|
          local_position = [x, y]

          # Empty space
          pixel = options[:symbol_for_empty]

          # Map obstacles
          pixel = options[:symbol_for_obstacle] if map.obstacles.member?(local_position)

          buffer << pixel
        end
        buffer << "\n"
      end
      buffer
    end
  end
end
