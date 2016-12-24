module Modules
  module Animation

    class Animation
      attr_reader :current_image

      @@animation_images = {}
      @@configs = {}

      class << self
        def load_from_file(path)
          unless @@configs[path]
            ani_data = JSON::load(File.read(path + ".json"))
            @@configs[path] = ani_data
            tiles = Gosu::Image.load_tiles($WINDOW, path + ".png", ani_data["sprite_width"], ani_data["sprite_height"], true)

            ani_data["animations"].each do |ani|
              @@animation_images[path] ||= {}
              @@animation_images[path][ani["name"]] ||= tiles[ani["start_index"]..ani["end_index"]]
            end
          end

          @@configs[path]
        end
      end

      def initialize(path, name)
        @resource_path = path
        @name = name

        temp = self.class.load_from_file(@resource_path)
        @config = temp["animations"].select {|ani| ani["name"] == name}.first
        # @config = self.class.load_from_file(@resource_path).select {|ani| ani["name"] == name}.first

        @ticks = 0
        @current_frame = 0

        @current_image = @@animation_images[@resource_path][@name][0]
      end

      def tick
        @ticks += 1

        if @ticks == @config["ticks_per_frame"]
          @current_frame += 1
          @ticks = 0
          if @current_frame == @@animation_images[@resource_path][@name].count
            @current_frame = 0
          end
          @current_image = @@animation_images[@resource_path][@name][@current_frame]
        end
      end
    end

    def update
      @current_animation.tick if @current_animation
    end

    def set_animation(name)
      # In general, animations, `current_image`, etc... those should be in forms huh?
      path = File.join($ANIMATIONS_DIR, self.attributes["class"])
      @current_animation = Animation.new(path, name)
    end

    def current_image
      if self.attributes["image"]
        if @current_image_path != self.attributes["image"]
          @current_image = Image.load(self.attributes["image"])
          @current_image_path = self.attributes["image"]
        end
        @current_image
      elsif @current_animation
        @current_animation.current_image
      end
    end
  end
end
