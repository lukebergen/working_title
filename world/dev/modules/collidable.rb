module Modules
  module Collidable
    def collides_with?(other)
      overlap_in_col = self["x"] + self["width"] >= other["x"] && self["x"] <= other["x"] + other["width"]
      overlap_in_row = self["y"] + self["height"] >= other["y"] && self["y"] <= other["y"] + other["height"]

      overlap_in_row && overlap_in_col
    end

    def valid?
      # TODO: New idea, modules can define a valid? method
      # That if it returns false, the game... what? nopes out
      # of trying to load it? Renders it as best it can in the
      # durpiest of broken ways?
      #
      # At the very least, valid? could be a way of ensuring
      # certain attributes and such for other methods to rely
      # on. So for instance, if valid? checks for x, y, image
      # Then the "draw" method can rest easy and not bother with
      # any kind of type/existence checking.
    end
  end
end
