require 'json'

class GameObject

  class << self
    def load(path, game)
      inst = self.new(path, game)

      file_str = File.read(path)
      pieces = file_str.split(/^__END__$/)
      if pieces.length > 1
        attrs = JSON::load(pieces[1])
      else
        attrs = {}
      end
      inst.instance_variable_set(:@attributes, attrs)
      inst.instance_eval(file_str)
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
    @installed_modules = []
  end

  def save
    self.class.save(self, @source_path)
  end

  def attributes
    @attributes
  end

  def on(message, &block)
    @game.register_listener(message, self, &block)
  end

  def use(mod)
    unless uses?(mod) # prevent re-loading same module multiple times (dependency loops)
      @installed_modules << mod
      extend Modules.const_get(mod)
    end
  end

  def uses?(mod)
    @installed_modules.include?(mod)
  end

  def is?(id)
    @attributes["id"] == id
  end

  def [](k)
    @attributes[k]
  end

  def []=(k, v)
    @attributes[k] = v
  end
end
