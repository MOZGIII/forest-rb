require 'set'
require 'json'

$: << '../lib'
require 'ai_framework'

def print_usage
  puts "Usage: #{$0} json_options"
  true
end

if $0 == __FILE__
  arg = ARGV.shift || "{}"
  begin
    options = Utils::Helpers.symbolize_keys(::JSON.parse(arg))
  rescue Exception => e
    puts "Invalid options passed!"
    print_usage
    puts
    puts "Input error: "
    p e
    exit
  end

  # Default options
  options[:map_file]       ||= "map.json"
  options[:solution_file]  ||= "solution.json"
  options[:map_options]    ||= {}
  options[:start_position] ||= [0, 0]
  options[:frame_delay]    ||= 0.3

  map_loader = MapLoader.new(options[:map_file])
  map = map_loader.load(options[:map_options])
  solution = ::JSON.parse(File.read(options[:solution_file]))["actions"] rescue [ "spawn" ]

  renderer_options = {
    start_position:       options[:start_position],
    target_position:      options[:target_position],
    horizontal_viewport:  options[:horizontal_viewport],
    vertical_viewport:    options[:vertical_viewport],
  }

  viewport_calculator = ViewportCalculator.new(map)
  renderer_options[:horizontal_viewport] ||= viewport_calculator.horizontal
  renderer_options[:vertical_viewport]   ||= viewport_calculator.vertical

  ir = IterativeRenderer.new(map, solution, renderer_options)
  ir.animate! options[:frame_delay].to_f
end
