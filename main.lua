-- code  from: https://github.com/Sulunia/isomap-love2d
-- email: pedrorocha@gec.inatel.br

-- fork by Fantalic
-- email: shengluChan@protonmail.com

-- [dev]
--debugging with lovebird (?) under : http://127.0.0.1:8000

require "core/globals"
local scene = require "editor/scene"

function love.load()
	-- set global values
	local x,y = love.graphics.getDimensions( )
	gWinSize.x = x
	gWinSize.y = y

	--Set background to deep blue
	love.graphics.setBackgroundColor(0, 0, 69)
	love.graphics.setDefaultFilter("linear", "linear", 8)

  if (not scene.load) then return end
	scene:load()

end

function love.update(dt)
	-- debuging under : http://127.0.0.1:8000
	--lovebird.update()
	if(not scene.update) then return end
	scene:update(dt)
end

function love.draw()

	-- [debug infos]
	info = love.graphics.getStats()
	love.graphics.print("FPS: "..love.timer.getFPS())
	love.graphics.print("Draw calls: "..info.drawcalls, 0, 12)
	love.graphics.print("Texture memory: "..((info.texturememory/1024)/1024).."mb", 0, 24)

	-- love.graphics.print("X: "..math.floor(x).." Y: "..math.floor(y), 0, 48)
	-- love.graphics.print("clickd tile x: ".. clickedTile.x .. " y: ".. clickedTile.y, 0, 60)

	if(not scene.draw) then return end
	scene:draw()

end

function love.mousereleased(x, y, button, isTouch)

	if(not scene.mousereleased) then return end
	scene:mousereleased(x,y,button, isTouch)
end

function love.wheelmoved(x, y)
	if(not scene.wheelmoved) then return end
	scene:wheelmoved(x,y)
end

function love.keypressed(key, scancode, isrepeat)
	if(not scene.keypressed) then return end
	scene:keypressed(key,scancode,isrepeat)
end

function love.keyreleased(key)
	if(not scene.keyreleased) then return end
	scene:keyreleased()
end
