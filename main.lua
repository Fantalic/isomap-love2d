-- code from: https://github.com/Sulunia/isomap-love2d
-- email: pedrorocha@gec.inatel.br

local anim8 = require("lib/anim8/anim8")
local lovebird = require("lib/lovebird")
isomap = require ("core/isomap")
utils = require ("core/uUtils")
local world = require "maps/world"

local winWidth, winHeight = love.graphics.getDimensions( )
local clickPosX = 0
local clickPosY = 0
local clickedTile = nil
local player = {anim=nil}
player.width = 16
player.height = 32

local pixelSize = 8
local spriteSrcOffY = 6 * pixelSize
local spriteSrcOffX = 6 * pixelSize
local animationGrid = nil

local clickedTile=nil

function love.load()
	--Variables
	print("time ? ")
	print(os.time())
	world.load(os.time())
	x = 0
	y = 0
	zoomL = 1
	zoom = 1

	--Set background to deep blue
	love.graphics.setBackgroundColor(0, 0, 69)
	love.graphics.setDefaultFilter("linear", "linear", 8)

  -- load map
	isomap.load("testmap")
	isomap.generatePlayField()

	player.spriteSheet = love.graphics.newImage("assets/characters/character1.png")
	local w = player.spriteSheet:getWidth()
	local h = player.spriteSheet:getHeight()
	local speed = 0.2
	player.grid = anim8.newGrid(16*pixelSize-4,24*pixelSize,w,h)--
	player.animations = {}
	player.animations.down = anim8.newAnimation(player.grid('1-3',1), speed)
	player.animations.up = anim8.newAnimation(player.grid('1-3',3), speed)
	player.animations.left = anim8.newAnimation(player.grid('1-3',2), speed)
  player.animations.right = anim8.newAnimation(player.grid('1-3',2),speed)
	player.anim = player.animations.down
end

function love.update(dt)
	lovebird.update()
	local isMoving = false
	local moveSpeed = 150
	local updownSpeed = moveSpeed/2

	if love.keyboard.isDown("left") then
		x = x + moveSpeed*dt
		isMoving = true
		player.anim = player.animations.left
	end
	if love.keyboard.isDown("right") then
		isMoving = true
		player.anim = player.animations.right
		x = x - moveSpeed*dt
	end
	if love.keyboard.isDown("up") then
		y = y+(updownSpeed)*dt
		isMoving = true
		player.anim = player.animations.up
	end
	if love.keyboard.isDown("down") then
		y = y-updownSpeed*dt
		isMoving = true
		player.anim = player.animations.down
	end

	if(isMoving == false) then
		player.anim:gotoFrame(2)
	else
		player.anim:update(dt)
	end
	zoomL = lerp(zoomL, zoom, 0.05*(dt*300))
end


function love.draw()
	isomap.drawGround(x, y, zoomL)
	isomap.drawObjects(x, y, zoomL)

	local posX = winWidth/2 - (player.width*pixelSize)/2
	local posY = winWidth/2 - (player.height*pixelSize)/2
	if(clickedTile ~= nil) then
		love.graphics.setColor(0, 0, 0)
		local text = "x: "..clickedTile.x .. " y: ".. clickedTile.y
		love.graphics.print(text,clickedTile.x, clickedTile.y)
	 end

	love.graphics.setColor(1, 1, 1)
  player.anim:draw(player.spriteSheet,posX,posY,0,0.5,0.5)
	--love.graphics.draw(player.spriteSheet,animationGrid)

	--love.graphics.setColor(1, 1, 0)
	love.graphics.rectangle("fill", clickPosX,clickPosY, pixelSize,pixelSize)

	info = love.graphics.getStats()
	love.graphics.print("FPS: "..love.timer.getFPS())
	love.graphics.print("Draw calls: "..info.drawcalls, 0, 12)
	love.graphics.print("Texture memory: "..((info.texturememory/1024)/1024).."mb", 0, 24)
	love.graphics.print("Zoom level: "..zoom, 0, 36)
	love.graphics.print("X: "..math.floor(x).." Y: "..math.floor(y), 0, 48)

	love.graphics.print("tile info:", 0, 60)
end

function love.mousereleased(x, y, button, isTouch)
	-- body...
	clickPosX = x
	clickPosY = y

	clickedTile = isomap.getTileByPos(x,y)

end

function love.wheelmoved(x, y)
    if y > 0 then
      zoom = zoom + 0.1
    elseif y < 0 then
      zoom = zoom - 0.1
    end

	if zoom < 0.1 then zoom = 0.1 end
end

function lerp(a, b, rate) --EMPLOYEE OF THE MONTH
	local result = (1-rate)*a + rate*b
	return result
end
