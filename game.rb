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

    @player = @game_objects.find {|go| go.attributes["id"] == "player"}
    @camera = Camera.new(@window, @player)
  end

  def load_area(path)
    @current_map = ::Map.new(path, @window)
    @listeners = {}   # reset listeners. No sense in telling a chair to break in some other area or some such
    paths = Dir.glob(File.join(path, "*.rb"))
    @game_objects = paths.map {|path| GameObject.load(path, self) }
    (@listeners[:loaded] || []).each {|b| b.call}
  end

  def register_listener(message, &block)
    @listeners[message] ||= []
    @listeners[message] << block
  end

  def button_down(id)
    @listeners[:key_down] && @listeners[:key_down].each do |notify|
      notify.call(BUTTON_ID_TO_NAME[id])
    end

    case id
    when Gosu::KbEscape
      @window.close
    when Gosu::KbQ
      @window.close
    end
  end

  def button_up(id)
    @listeners[:key_up] && @listeners[:key_up].each do |notify|
      notify.call(BUTTON_ID_TO_NAME[id])
    end

    case id
    when Gosu::KbT
      @player.save
    end
  end

  def update
    @listeners[:update] && @listeners[:update].each do |notify|
      notify.call
    end

    @camera.x = @player.attributes['x']
    @camera.y = @player.attributes['y']
  end

  def draw
    @camera.draw(@current_map)
    @game_objects.each do |obj|
      @camera.draw(obj)
    end
  end

  private
  def player_path
    File.dirname(Dir.glob(File.join(@root, "**", "player.rb"))[0])
  end
end
