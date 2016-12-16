#!/usr/bin/env ruby

require 'gosu'
require 'json'

require './game_object'
require './camera'
require './image'
require './map'
require './animation'

$ASSETS_DIR = "./assets/"
$ANIMATIONS_DIR = File.join($ASSETS_DIR, "animations")
$TILES_DIR = File.join($ASSETS_DIR, "tilesets")
$WORLD_DIR = "./world"

WIN_WIDTH = 800
WIN_HEIGHT = 600

class Main < Gosu::Window
  def initialize
    super(WIN_WIDTH, WIN_HEIGHT)
    $WINDOW = self
    @movement = [0, 0]

    @game_objects = []
    load_area("./world/dev")
    $CAMERA = Camera.new($WINDOW)
  end

  def load_area(path)
    @map = ::Map.new(path)
    Dir.glob(File.join(path, "*.rb")).each do |path|
      obj = GameObject.load(path)
      @game_objects << obj
      if obj.attributes["id"] == "player"
        @player = obj
        @player.set_animation("idle")
      end
    end
  end

  def button_down(id)
    previous_player_direction = @player.attributes['direction']
    case id
    when Gosu::KbUp
      @movement[1] -= @player.attributes["speed"]
      @player.attributes["direction"] = "up"
    when Gosu::KbDown
      @movement[1] += @player.attributes["speed"]
      @player.attributes["direction"] = "down"
    when Gosu::KbLeft
      @movement[0] -= @player.attributes["speed"]
      @player.attributes["direction"] = "left"
    when Gosu::KbRight
      @movement[0] += @player.attributes["speed"]
      @player.attributes["direction"] = "right"
    when Gosu::KbEscape
      close
    end

    if @player.attributes["direction"] != previous_player_direction
      path = @player.attributes["class"] + File::Separator + @player.attributes["state"]
      @player.set_animation("walk_#{@player.attributes['direction']}")
    end
  end

  def button_up(id)
    case id
    when Gosu::KbUp
      @movement[1] += @player.attributes["speed"]
    when Gosu::KbDown
      @movement[1] -= @player.attributes["speed"]
    when Gosu::KbLeft
      @movement[0] += @player.attributes["speed"]
    when Gosu::KbRight
      @movement[0] -= @player.attributes["speed"]
    when Gosu::KbT
      @player.save
    end
  end

  def update
    @player.attributes['x'] += @movement[0]
    @player.attributes['y'] += @movement[1]
    @player.update
    $CAMERA.x = @player.attributes['x']
    $CAMERA.y = @player.attributes['y']
  end

  def draw
    $CAMERA.draw(@map)
    @game_objects.each do |obj|
      $CAMERA.draw(obj)
    end
  end

  private
  def player_path
    File.dirname(Dir.glob("**/player.rb")[0])
  end
end

m = Main.new
m.show
