-- code  from: https://github.com/Sulunia/isomap-love2d
-- email: pedrorocha@gec.inatel.br

-- fork by Fantalic
-- email: shengluChan@protonmail.com

--debugging under : http://127.0.0.1:8000
local lovebird = require("lib/lovebird")

local isomap = require ("core/isomap")
local utils = require ("core/uUtils")
local world = require "maps/world"
local player = require ("assets/characters/player/player")

local clickPosX = 0
local clickPosY = 0
local clickedTile = {x=0,y=0}

local pixelSize = 8
local spriteSrcOffY = 6 * pixelSize
local spriteSrcOffX = 6 * pixelSize
local animationGrid = nil
local x = 0
local y = 0


function love.load()
	--Set background to deep blue
	love.graphics.setBackgroundColor(0, 0, 69)
	love.graphics.setDefaultFilter("linear", "linear", 8)

	-- load random world (minimap)
	-- world.load(os.time())

  -- load map
	isomap.load("testmap")

	player.load()
end

function love.update(dt)
	-- debuging under : http://127.0.0.1:8000
	--lovebird.update()
	player.update(dt)
	isomap.update(dt)
end


function love.draw()
	isomap.draw(player)

  --love.graphics.setColor(1, 1, 1)

	--love.graphics.draw(player.spriteSheet,animationGrid)

	--love.graphics.setColor(1, 1, 0)
	love.graphics.rectangle("fill", clickPosX,clickPosY, pixelSize,pixelSize)

	info = love.graphics.getStats()
	love.graphics.print("FPS: "..love.timer.getFPS())
	love.graphics.print("Draw calls: "..info.drawcalls, 0, 12)
	love.graphics.print("Texture memory: "..((info.texturememory/1024)/1024).."mb", 0, 24)

	love.graphics.print("X: "..math.floor(x).." Y: "..math.floor(y), 0, 48)
	love.graphics.print("clickd tile x: ".. clickedTile.x .. " y: ".. clickedTile.y, 0, 60)

end

function love.mousereleased(x, y, button, isTouch)
	-- body...
	clickPosX = x
	clickPosY = y
	clickedTile = isomap.getTileByPos(x,y)

  isomap.insertNewObject(clickedTile.x,clickedTile.y,"tree",1.5)
--	get tile and replace texture

end

function love.wheelmoved(x, y)
  isomap.wheelmoved(x,y)
end
