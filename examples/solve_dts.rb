$: << '../lib'
require 'ai_framework'

map = MapFormat::AsciiGraphics.load("example_map_small.txt", offset: [-1, -1])
world = World.new(map)
agent = Agent.new

# Define initial and target states
start_state  = PositionedState.new(agent, Position.new(0, 0))
target_state = PositionedState.new(agent, Position.new(9, 9))

# Boot agent sesnors by binding them to the world or each other
agent.sensors.boot!({
  WorldCollisionSensor => { world: world },
  DesiredStateSensor   => { target_state: target_state },
})

# Build a list of all actions we allow our agent to perform during this search.
# This is not necessarily a list of all actions that the agent supports,
# for example we could only allow agent to move up and right, and then
# the search will be performed with only considering these actions at each step.
allowed_actions = begin
  # Build an array of 8 MoveActions - 1 for each possible direction.
  arr = []
  [1, 0, -1].each do |ver|
    [-1, 0, 1].each do |hor|
      next if ver == 0 && hor == 0 # there is no such direction
      arr << MoveAction.new(Direction.new(hor, ver))
    end
  end
  arr
end

context = SearchContext.new(
  world: world,
  agent: agent,
  target_state: target_state,
  allowed_actions: allowed_actions
)

pathfinder_class = Pathfinder::DoubleTreeSearch
searcher = pathfinder_class.new(context)
fringe = SearchableFringeFIFO.new

# Save map in our format
MapFormat::Json.save(map, "map.json")

start_root_node = pathfinder_class.build_root_node(SpawnAction.new, start_state)
end_root_node   = pathfinder_class.build_root_node(SpawnAction.new, target_state)
solution = searcher.search(fringe, start_root_node, end_root_node)
unless solution
  STDERR.puts "Solution not found!"
  STDERR.puts "No route from #{start_state.position.to_a} to #{target_state.position.to_a}"
  exit 1
end

# Print solution on the screen
solution.each do |action|
  puts action
end

# Export to various formats
SolutionExporter.export(solution, "solution.json", SolutionEncoder::Json)
SolutionExporter.export(solution, "solution.txt", SolutionEncoder::Strings)
SolutionExporter.export(solution, "solution-cstyle.txt", SolutionEncoder::CStyle)
