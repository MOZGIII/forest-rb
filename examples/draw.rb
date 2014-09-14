$: << '../lib'
require 'ai_framework'

if $0 == __FILE__
  map = MapFormat::AsciiGraphics.load("example_map.txt", offset: [-1, -1])

  puts MapFormat::AsciiGraphics.to_ascii_graphics(map,
    horizontal_viewport: (-1...40),
    vertical_viewport:   (-1...40),
  )
end
