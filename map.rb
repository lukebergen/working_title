require 'json'

class Map

  @@loaded_images = {}

  def initialize(path)
    @map = JSON.parse(File.read(File.join([path, "map.json"])))
    @tiles = {}

    @map["tilesets"].each do |ts|
      first_gid = ts["firstgid"] || 1
      @@loaded_images[ts["image"]] ||= Gosu::Image.load_tiles($WINDOW, File.join([$TILES_DIR, ts["image"]]), ts["tilewidth"], ts["tileheight"], true)
      @@loaded_images[ts["image"]].each_with_index do |img, i|
        @tiles[first_gid + i] = img
      end
    end

    @full_image = $WINDOW.record(@map["height"] * @map["tileheight"], @map["width"] * @map["tilewidth"]) do
      @map["layers"].each_with_index do |layer, z|
        x = 0
        y = 0
        layer["data"].each do |tile_id|
          if x >= layer["width"] * @map['tilewidth']
            x = 0
            y += @map["tileheight"]
          end
          if tile_id > 0
            @tiles[tile_id].draw(x, y, z)
          end
          x += @map["tilewidth"]
        end
      end
    end
  end

  def draw(x, y, z)
    @full_image.draw(x, y, z)
  end

  def current_image
    @full_image
  end

  def attributes
    {}
  end
end
