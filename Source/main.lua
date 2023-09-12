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

  -- function to iterate through table and set tiles
  local function setTiles(tiles, tilesetKey)
    for i = 1, #tiles do
      tilemap[tiles[i] + 1] = tilesetKeyTranslation[tilesetKey]
    end
  end

  -- Set the tiles
  setTiles(level.walls, "walls")
  setTiles(level.torches, "torches")
  setTiles(level.ladders, "ladders")
  setTiles(level.holes, "holes")
  setTiles(level.planks, "planks")
  setTiles(level.coins, "coins")
  setTiles(level.exit, "exit")

  -- Create a tilemap object
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