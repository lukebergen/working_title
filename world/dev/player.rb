use "Animation"

on :loaded do
  # on x (left/right) 0 is stand still, -1 is move left, +1 is move right. On y (up/down), 0 is stand still, -1 is up, and +1 is down. So {x: 1, y: 0} means moving right. {x: -1, y: 1} represents moving left and down (diagonally).
  @movement = {x: 0, y: 0}  # start out standing still
  animation_name = "idle_" + @attributes["direction"]
  set_animation(animation_name)
end

on :update do
  @attributes["x"] += @movement[:x]
  @attributes["y"] += @movement[:y]
  self.update
end

on :key_down do |key|
  case key
  when :left
    @movement[:x] -= @attributes["speed"]
    @attributes["direction"] = "left"
    set_animation("walk_left")
  when :right
    @movement[:x] += @attributes["speed"]
    @attributes["direction"] = "right"
    set_animation("walk_right")
  when :up
    @movement[:y] -= @attributes["speed"]
    @attributes["direction"] = "up"
    set_animation("walk_up")
  when :down
    @movement[:y] += @attributes["speed"]
    @attributes["direction"] = "down"
    set_animation("walk_down")
  when :m
    puts "instaled_modules: #{@installed_modules.join(', ')}"
  end
end

on :key_up do |key|
  case key
  when :left
    @movement[:x] += @attributes["speed"] if @movement[:x] < 0
  when :right
    @movement[:x] -= @attributes["speed"] if @movement[:x] > 0
  when :up
    @movement[:y] += @attributes["speed"] if @movement[:y] < 0
  when :down
    @movement[:y] -= @attributes["speed"] if @movement[:y] > 0
  end

  if @movement[:x] == 0 && @movement[:y] == 0
    idle_animation = "idle_" + @attributes["direction"]
    set_animation(idle_animation)
  end
end
__END__
{
  "id": "player",
  "class": "player",
  "state": "idle",
  "direction": "right",
  "x": 248,
  "y": 240,
  "z": 3,
  "speed": 4
}