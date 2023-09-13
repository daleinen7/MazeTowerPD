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

-- Load the player character sprite from the tileset (assuming tile 26 is the player character)
local playerSprite = gfx.tilemap.new()
playerSprite:setImageTable(tilesheet)
playerSprite:setTiles({26}, 1)

local player = gfx.sprite.new(playerSprite)

player:add()

player:moveTo(120, 232)

playerX, playerY = 120, 232

function pd.update()

  -- Check for arrow key presses and update player coordinates
    if pd.buttonJustPressed(pd.kButtonUp) then
        playerY = playerY - 16
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        playerY = playerY + 16
    elseif pd.buttonJustPressed(pd.kButtonLeft) then
        playerX = playerX - 16
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        playerX = playerX + 16
    end

    -- Update the player's position
    player:moveTo(playerX, playerY)

	gfx.sprite.update()
	pd.timer.updateTimers()
end