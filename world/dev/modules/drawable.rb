module Modules
  module Drawable
    def current_image
      if self.attributes["image"]
        if @current_image_path != self.attributes["image"]
          @current_image = Image.load(self.attributes["image"])
          @current_image_path = self.attributes["image"]
        end
        @current_image
      else
        # set current_image to a broken image icon or something
        puts "oops"
      end
    end
  end
end
