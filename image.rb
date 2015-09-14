class Image
  @@loaded_images = {}

  class << self
    def load(path)
      @@loaded_images[path] ||= Gosu::Image.new(path)
      @@loaded_images[path]
    end
  end
end
