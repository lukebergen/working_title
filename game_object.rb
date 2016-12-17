require 'json'

class GameObject

  class << self
    def load(path, game)
      inst = self.new(path, game)
      file_str = File.read(path)
      inst.instance_eval(file_str)
      
      pieces = file_str.split(/^__END__$/)
      if pieces.length > 1
        attrs = JSON::load(pieces[1])
      else
        attrs = {}
      end
      inst.instance_variable_set(:@attributes, attrs)
      inst
    end

    def save(obj, path)
      str = File.read(path)
      code = str.split(/^__END__$/)[0].strip
      attrs = JSON::pretty_generate obj.attributes
      new_file = "#{code}\n__END__\n#{attrs}"
      File.open(path, 'w') {|f| f.write(new_file)}
    end
  end

  def initialize(source_path, game)
    @source_path = source_path
    @game = game
  end

  def save
    self.class.save(self, @source_path)
  end

  def attributes
    @attributes
  end

  def on(message, &block)
    @game.register_listener(message, &block)
  end

  def [](k)
    @attributes[k]
  end

  def [](k, v)
    @attributes[k] = v
  end

  def set_animation(name)
    # In general, animations, `current_image`, etc... those should be in forms huh?
    path = File.join($ANIMATIONS_DIR, self.attributes["class"])
    @current_animation = Animation.new(path, name)
  end

  def update
    @current_animation.tick if @current_animation
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
