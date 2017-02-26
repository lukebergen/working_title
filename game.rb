require 'fileutils'

class Game
  attr_reader :window

  BUTTON_ID_TO_NAME = {}
  Gosu.constants.select {|c| c =~ /^Kb/}.each do |const|
    id = Gosu.const_get(const)
    BUTTON_ID_TO_NAME[id] = const.to_s.gsub(/^Kb/, '').downcase.to_sym
  end

  def initialize(window, root)
    @window = window
    @root = root

    load_area(player_path)
  end

  def load_area(path)
    @current_area_path = path
    @current_map = ::Map.new(path, @window)
    @listeners = {}   # reset listeners. No sense in telling a chair to break in some other area or some such
    paths = Dir.glob(File.join(path, "*.rb"))
    @game_objects = paths.map {|path| GameObject.load(path, self) }
    (@listeners[:loaded] || []).each {|listener| listener[:block].call}

    @player = @game_objects.find {|go| go.attributes["id"] == "player"}
    @camera = Camera.new(@window, @player)
  end

  def move_to_area(new_path, x = 0, y = 0)
    @player["x"] = x
    @player["y"] = y
    @player.save
    FileUtils.mv(File.join(@current_area_path, "player.rb"), new_path)
    load_area(new_path)
  end

  def register_listener(message, obj, &block)
    @listeners[message] ||= []
    @listeners[message] << {object: obj, block: block}
  end

  def button_down(id)
    @listeners[:key_down] && @listeners[:key_down].each do |listener|
      listener[:block].call(BUTTON_ID_TO_NAME[id])
    end

    case id
    when Gosu::KbEscape
      @window.close
    when Gosu::KbQ
      @window.close
    end
  end

  def button_up(id)
    @listeners[:key_up] && @listeners[:key_up].each do |listener|
      listener[:block].call(BUTTON_ID_TO_NAME[id])
    end

    case id
    when Gosu::KbT
      @player.save
    end
  end

  def update
    @listeners[:update] && @listeners[:update].each do |listener|
      listener[:block].call
    end

    handle_game_events

    @camera.x = @player.attributes['x']
    @camera.y = @player.attributes['y']
  end

  def draw
    @camera.draw(@current_map)
    @game_objects.select{|go| go.uses?("Drawable") || go.uses?("Animation")}.each do |obj|
      @camera.draw(obj)
    end
  end

  private
  def player_path
    File.dirname(Dir.glob(File.join(@root, "**", "player.rb"))[0])
  end

  def handle_game_events
    # collision events
    collideables = @game_objects.select {|go| go.uses?("Collidable") }
    collideables.each do |game_object|
      collideables.each do |other|
        next if game_object == other # can't collide with self, silly

        if game_object.collides_with?(other)
          # Figure out push back here?
          # There may be other collision based events that we fire as well
          # So it probably still makes sense to check collides_with at this
          # level and then deciding what listeners to fire
          # At the very least, yeah, check if they're watching touched_by
          listener = get_listener(:touched_by, other)
          if listener
            listener[:block].call(game_object)
          end
        end
      end
    end
  end

  def get_listener(message, obj)
    (@listeners[message] || []).find{|listener| listener[:object]["id"] == obj["id"]}
  end
end
