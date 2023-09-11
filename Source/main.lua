import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"
import "CoreLibs/crank"
import "CoreLibs/animation"

import "levels"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Set background to black
gfx.setColor(gfx.kColorBlack)
gfx.fillRect(0, 0, 400, 240)
gfx.setBackgroundColor(gfx.kColorBlack)

-- Import the tileset
tilesheet = gfx.imagetable.new("Images/onebit")

-- local player = Player(100, 60, gfx.imagetable.new("images/mazzy"))
-- player:add()

currentLevel = 1

-- Create an empty tilemap
local tilemap = {}

function buildLevel(level)
  local tilesetKeyTranslation = {
    walls = 844,
    torches = 845,
    ladders = 846,
    holes = 847,
    planks = 848,
    coins = 849,
    exit = 850
  }

  -- Create an empty tilemap
  -- Initialize the tilemap with empty tiles
  for i = 1, 225 do
    tilemap[i] = 0
  end

  -- Iterate through each tile type needing added
  for tile, positions in pairs(level) do

		print("TILE: " .. tile)

		print("POSITIONS: ")
		print(positions)

		print("TILESET KEY TRANSLATION: ")
		print(tilesetKeyTranslation[tile])
		
    -- Iterate through each position needing added
    for i = 1, #level do
      -- Add the tile to the tilemap

      print("What is this note")
      print(tile)
      tilemap[positions[i]] = tile
    end
  end

  tm = gfx.tilemap.new()
  tm:setImageTable(tilesheet)
  tm:setTiles(tilemap, 15)
  tm:draw(0, 0)

  background = gfx.sprite.new(tm)
  background:setCenter(0, 0)
  background:add()
end

buildLevel(levels[currentLevel])

print(levels[1])

function pd.update()

	if pd.buttonJustPressed(pd.kButtonA) then
		tm:setTileAtPosition(2, 2, 6)
		tm:draw(0, 0)
	end

	gfx.sprite.update()
	pd.timer.updateTimers()
end