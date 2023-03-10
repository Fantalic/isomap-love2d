-- code  from: https://github.com/Sulunia/isomap-love2d
-- email: pedrorocha@gec.inatel.br

-- fork by Fantalic
-- email: shengluChan@protonmail.com

-- [dev]
--debugging with lovebird (?) under : http://127.0.0.1:8000

-- loads a default scene TODO: split file to scene and main


local lovebird = require("lib/lovebird")
--local world = require "maps/world"
local inGame = require("core/scene/inGame")
--local rigitbody = require "core/rigitbody"
local testGUI = require("editor/GUI")

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


local scene = {}

function scene:load()
	--Set background to deep blue
	love.graphics.setBackgroundColor(0, 0, 69)
	love.graphics.setDefaultFilter("linear", "linear", 8)

  -- load editor
  -- editor:load()

	-- load random world ( minimap )
	-- world.load( os.time() )

  --load in game scene
	inGame:load()
	testGUI:load()
end

function scene:update(dt)
	-- debuging under : http://127.0.0.1:8000
	--lovebird.update()
	 testGUI:update(dt)
	 inGame:update(dt)
end


function scene:draw()
	-- grid.draw()
	-- isomap:draw(camera.zoom)
	--rigitbody:draw()
	-- love.graphics.rectangle("fill", clickPosX,clickPosY, pixelSize,pixelSize)

	inGame:draw()
	testGUI:draw()
	--editor:draw()

	-- [debug infos]
	info = love.graphics.getStats()
	love.graphics.print("FPS: "..love.timer.getFPS())
	love.graphics.print("Draw calls: "..info.drawcalls, 0, 12)
	love.graphics.print("Texture memory: "..((info.texturememory/1024)/1024).."mb", 0, 24)

	love.graphics.print("X: "..math.floor(x).." Y: "..math.floor(y), 0, 48)
	love.graphics.print("clickd tile x: ".. clickedTile.x .. " y: ".. clickedTile.y, 0, 60)

end

function scene:mousereleased(x, y, button, isTouch)
	--editor:mousereleased(x, y, button, isTouch)
		-- body...

	-- if event return true, the event is stoped
	if (testGUI:mousereleased(x,y,button,isTouch)) then
		return
	end
	if(inGame:mousereleased(x,y,button,isTouch)) then return end
end

function scene:wheelmoved(x, y)
  inGame:wheelmoved(x,y)
end

function scene:keypressed(key, scancode, isrepeat)
	inGame:keypressed(key)
end

function scene:keyreleased(key)

	inGame:keyreleased(key)
end

return scene
