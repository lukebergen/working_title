on :loaded do
  # on x (left/right) 0 is stand still, -1 is move left, +1 is move right. On y (up/down), 0 is stand still, -1 is up, and +1 is down. So {x: 1, y: 0} means moving right. {x: -1, y: 1} represents moving left and down (diagonally).
  @movement = {x: 0, y: 0}  # start out standing still
  set_animation("idle")
end

on :update do
  @attributes["x"] += @movement[:x]
  @attributes["y"] += @movement[:y]
  self.update
end

on :key_down do |key|
  previous_direction = attributes["direction"]

  case key
  when :left
    @movement[:x] -= @attributes["speed"]
    attributes["direction"] = "left"
  when :right
    @movement[:x] += @attributes["speed"]
    attributes["direction"] = "right"
  when :up
    @movement[:y] -= @attributes["speed"]
    attributes["direction"] = "up"
  when :down
    @movement[:y] += @attributes["speed"]
    @attributes["direction"] = "down"
  end

  if @attributes["direction"] != previous_direction
    animation_name = "walk_" + @attributes["direction"]
    set_animation(animation_name)
  end
end

on :key_up do |key|
  case key
  when :left
    @movement[:x] += @attributes["speed"]
  when :right
    @movement[:x] -= @attributes["speed"]
  when :up
    @movement[:y] += @attributes["speed"]
  when :down
    @movement[:y] -= @attributes["speed"]
  end

  if @movement[:x] == 0 && @movement[:y] == 0
    #set_animation("idle")
  end
end

__END__
{
  "id": "player",
  "class": "player",
  "state": "idle",
  "direction": "up",
  "x": 200,
  "y": 172,
  "z": 3,
  "speed": 4
}
