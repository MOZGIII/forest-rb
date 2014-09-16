$: << '../lib'
require 'ai_framework'


if $0 == __FILE__
  filename = ARGV.shift || "example_map.txt"

  options = {
    horizontal_viewport: (0...10),
    vertical_viewport:   (0...10),
  }

  offset = [0, 0]

  while arg = ARGV.shift
    case arg
    when "-w", "-H", "-x"
      options[:horizontal_viewport] = (ARGV.shift.to_i .. ARGV.shift.to_i)
    when "-h", "-V", "-y"
      options[:vertical_viewport]   = (ARGV.shift.to_i .. ARGV.shift.to_i)
    when "-O"
      offset = [ ARGV.shift.to_i, ARGV.shift.to_i ]
    else
      puts "Usage: #{$0} filename [-w x y] [-h x y] [-O x y]"
      puts
      puts "Specify viewport with -w and -h and offset with -O"
      exit
    end
  end

  map = MapFormat::AsciiGraphics.load(filename, offset: offset)
  puts MapFormat::AsciiGraphics.to_ascii_graphics(map, options)
end
