class Camera
  attr_accessor :x, :y, :window

  def initialize(win)
    @window = win
    @x = 0
    @y = 0
  end

  def draw(obj, manual_x=nil, manual_y=nil)
    if manual_x || manual_y
      dx = manual_x
      dy = manual_y
    else
      dx = obj.attributes.fetch('x', 0) - @x + (@window.width / 2.0)
      dy = obj.attributes.fetch('y', 0) - @y + (@window.height / 2.0)
    end

    obj.current_image.draw(dx, dy, obj.attributes.fetch('z', 0))
  end
end
