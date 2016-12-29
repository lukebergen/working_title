#!/usr/bin/env ruby

require 'gosu'
require 'json'

require './game'
require './game_object'
require './camera'
require './image'
require './map'

Dir.glob("./world/dev/modules/*.rb").each do |file|
  require file
end

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
    @game = Game.new(self, ".")
  end

  def button_down(id)
    @game.button_down(id)
  end

  def button_up(id)
    @game.button_up(id)
  end

  def update
    @game.update
  end

  def draw
    @game.draw
  end

end

m = Main.new
m.show
