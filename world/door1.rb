use "Drawable"
use "Collidable"

on :touched_by do |other_object|
  if other_object.is?("player")
    @game.move_to_area(attributes["warp_to_area"], attributes["warp_to_x"], attributes["warp_to_y"])
  end
end

__END__
{
  "id": "door1",
  "class": "door",
  "image": "assets/images/door_closed.png",
  "x": 100,
  "y": 100,
  "height": 64,
  "width": 64,
  "warp_to_area": "world/dev",
  "warp_to_x": 332,
  "warp_to_y": 365
}
