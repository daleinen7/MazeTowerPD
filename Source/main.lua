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

local lerpFactor = 0.5

function isValueInTable(value, table)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function playerIsNotBlocked(x, y, direction)
  -- Convert pixel coordinates to tile coordinates
  local tileX = (math.floor(x / 16)) + 1
  local tileY = (math.floor(y / 16)) + 1

  print('--- BEFORE ---')
  print(tileX)
  print('---')
  print(tileY)
  print('---')


  -- Check the direction and adjust the tile coordinates accordingly
  if direction == "up" then
    tileY = tileY - 1
  elseif direction == "down" then
    tileY = tileY + 1
  elseif direction == "left" then
    tileX = tileX - 1
  elseif direction == "right" then
    tileX = tileX + 1
  end

  print('---')
  print('--- AFTER ---')
  print(tileX)
  print('---')
  print(tileY)
  print('---')

  print((tileY - 1) * 15 + tileX)

  -- print(isValueInTable((tileY - 1) * 15 + tileX, levels[currentLevel].walls))

  -- print(isValueInTable((tyleY - 1) * 15 + tileX, levels[currentLevel].walls))

  -- return  isValueInTable((tileY - 1) * 15 + tileX, levels[currentLevel].walls)
  return true
end

function pd.update()
  local targetX, targetY = playerX, playerY  -- Store the target coordinates

  -- Check for arrow key presses and update player coordinates
  if pd.buttonJustPressed(pd.kButtonUp) and playerIsNotBlocked(targetX, targetY - 16, "up") then
    playerY = playerY - 16
  elseif pd.buttonJustPressed(pd.kButtonDown) and playerIsNotBlocked(targetX, targetY + 16, "down") then
    playerY = playerY + 16
  elseif pd.buttonJustPressed(pd.kButtonLeft) and playerIsNotBlocked(targetX - 16, targetY, "left") then
    playerX = playerX - 16
  elseif pd.buttonJustPressed(pd.kButtonRight) and playerIsNotBlocked(targetX + 16, targetY, "right") then
    playerX = playerX + 16
  end

  -- Calculate the difference between the current and target positions
  local deltaX = playerX - player.x
  local deltaY = playerY - player.y

  -- Apply linear interpolation to smooth the movement
  player.x = player.x + (deltaX * lerpFactor)
  player.y = player.y + (deltaY * lerpFactor)

  -- Update the player's position
  player:moveTo(player.x, player.y)

	gfx.sprite.update()
	pd.timer.updateTimers()
end