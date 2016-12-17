class Camera
  attr_accessor :x, :y, :window

  def initialize(win, attach_to = nil)
    @window = win
    @attach_to = attach_to
    @x = 0
    @y = 0
  end

  def attach(obj)
    @attach_to = obj
  end

  def draw(obj, manual_x=nil, manual_y=nil)
    return unless obj.current_image
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
