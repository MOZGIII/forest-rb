$: << '../lib'
require 'ai_framework'

def print_usage
  puts "Usage: #{$0} filename [-w x y] [-h x y] [-O x y]"
  puts
  puts "Specify viewport with -w and -h and offset with -O (only for ascii maps)"
  true
end


if $0 == __FILE__
  filename = ARGV.shift

  print_usage and exit unless filename

  options = {
    horizontal_viewport: nil,
    vertical_viewport:   nil,
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
      print_usage and exit
    end
  end

  map_loader = MapLoader.new(filename)
  map = map_loader.load(offset: offset)

  if !options[:horizontal_viewport] || !options[:vertical_viewport]
    vc = ViewportCalculator.new(map)

    options[:horizontal_viewport] ||= vc.horizontal
    options[:vertical_viewport]   ||= vc.vertical
  end

  puts MapFormat::AsciiGraphics.to_ascii_graphics(map, options)
end
