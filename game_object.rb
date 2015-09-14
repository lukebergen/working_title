require 'json'

class GameObject

  class << self
    def load(path)
      inst = self.new(path)
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

  def initialize(source_path)
    @source_path = source_path
  end

  def save
    self.class.save(self, @source_path)
  end

  def attributes
    @attributes
  end

  def [](k)
    @attributes[k]
  end

  def [](k, v)
    @attributes[k] = v
  end

  def set_animation(name)
    path = File.join($ANIMATIONS_DIR, self.attributes["class"])
    @current_animation = Animation.new(path, name)
  end

  def update
    @current_animation.tick
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
