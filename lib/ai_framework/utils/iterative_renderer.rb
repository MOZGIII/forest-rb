class IterativeRenderer
  def initialize(map, solution, options = {})
    @map = map
    @solution = solution

    @draw_mode = options[:draw_mode] || :all
    raise ArgumentError, "Unknown draw mode #{draw_mode.inspect}" unless [:all, :solution_only].member?(@draw_mode)

    @horizontal_viewport = options[:horizontal_viewport] || (0...10)
    @vertical_viewport   = options[:vertical_viewport]   || (0...10)

    @start_position   = options[:start_position] || [0, 0]
    @target_position  = options[:target_position]

    @route = Set.new
    @current_position = nil
    @step = 0
    @current_action = nil
  end

  def render_frame
    buffer = ""
    buffer << "== Step: #{@step}; Pos: #{@current_position}, Action: #{@current_action} ==\n"
    @horizontal_viewport.each do |y|
      @vertical_viewport.each do |x|
        local_position = [x, y]

        # Only draw map if asked
        if @draw_mode == :solution_only

          # Empty space
          pixel = " "

        else

          # Empty space
          pixel = "."

          # Map obstacles
          pixel = "#" if @map.obstacles.member?(local_position)

        end

        # Route
        pixel = "+" if @route.member?(local_position)

        # Target position
        pixel = "!" if @target_position && @target_position == local_position

        # Current position
        pixel = "@" if @current_position && @current_position == local_position

        buffer << pixel
      end
      buffer << "\n"
    end

    buffer
  end

  def step!
    @step += 1
    @current_action = @solution.shift

    case @current_action
    when "spawn"
      @current_position = @start_position
    else
      h_portion = @current_action.match(/left|right/)
      v_portion = @current_action.match(/up|down/)

      @current_position[0] += h_portion[0] == "left" ? -1 : 1 if h_portion
      @current_position[1] += v_portion[0] == "up"   ? -1 : 1 if v_portion
    end

    @route << @current_position.dup
  end

  def animate!(timeout = 0.5)
    until @solution.empty?
      step!
      buffer = ""
      buffer << "\e[H\e[2J\n" # clear screen
      buffer << render_frame
      buffer << "=" * 80
      puts buffer
      STDOUT.flush
      sleep(timeout)
    end
    puts "Done"
  end
end
