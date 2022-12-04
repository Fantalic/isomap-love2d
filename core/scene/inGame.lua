local isomap = require ("core/map/isomap")
local player = require ("core/player/player")
local keyboard = require ("core/keyboard")
local camera = require("core/scene/camera")


local InGame={

}

local clickPosX = 0
local clickPosY = 0
local clickedTile = {x=0,y=0}

local pixelSize = 8
local spriteSrcOffY = 6 * pixelSize
local spriteSrcOffX = 6 * pixelSize
local animationGrid = nil
local x = 0
local y = 0
local axeSheet = nil



function InGame:load()
	--Set background to deep blue
	love.graphics.setBackgroundColor(0, 0, 69)
	love.graphics.setDefaultFilter("linear", "linear", 8)

	-- load random world (minimap)
	 --world.load(os.time())

	-- load map
	isomap:load("test/testmap")
	isomap:insertNewObject(2,2,"axe")
	isomap:insertPlayer(player)

	-- [dev] testing a rigitbody
	--rigitbody.load()

  -- create Player movement control object
	local movementBindings = {
		up = "w",
		down = "s",
		left = "a",
		right = "d"
	}

	keyboard:addMovmentControl(
	  "playerMovement",
	  movementBindings,
		--onInput:
		function (dt,dir)
			player:move(dt,dir)
		end,
		-- onPause:
		function()
			player.isMoving = false
		end
	)

	-- create camera control
	local cameraMoveBindings = {
		up = "up",
		down = "down",
		left = "left",
		right = "right"
	}

	keyboard:addMovmentControl(
		"cameraMovement",
		cameraMoveBindings,
		--onInput:
		function (dt,dir)
			print(dir)
			local dx, dy = camera:move(dt,dir)
			-- move map
			isomap:onCameraMove(dx,dy)
		end
		-- onPause:
	)

end

function InGame:update(dt)
	--isomap:update(dt)
  keyboard:update(dt)
	player:update(dt)
end


function InGame:draw()
	isomap:draw(camera.zoom)
	-- love.graphics.rectangle("fill", clickPosX,clickPosY, pixelSize,pixelSize)

  -- [debug infos]
	info = love.graphics.getStats()
	love.graphics.print("FPS: "..love.timer.getFPS())
	love.graphics.print("Draw calls: "..info.drawcalls, 0, 12)
	love.graphics.print("Texture memory: "..((info.texturememory/1024)/1024).."mb", 0, 24)

	love.graphics.print("X: "..math.floor(x).." Y: "..math.floor(y), 0, 48)
	love.graphics.print("clickd tile x: ".. clickedTile.x .. " y: ".. clickedTile.y, 0, 60)


end

function InGame:mousereleased(x, y, button, isTouch)
	-- body...
	clickPosX = x
	clickPosY = y
	clickedTile = isomap.getTileByPos(x,y)
  --isomap.insertNewObject(clickedTile.x,clickedTile.y,"tree",0)
	isomap:insertNewObject(clickedTile.x,clickedTile.y,"tree",0)

end

function InGame:wheelmoved(x, y)
  isomap:wheelmoved(x,y)
end

function InGame:keypressed(key, scancode, isrepeat)
	keyboard:keypressed(key)
end

function InGame:keyreleased(key)
	keyboard:keyreleased(key)
end

return InGame
