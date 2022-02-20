local anim8 = require("lib/anim8/anim8")
local _C = require("constants")

local   speedFaktor = 150
local   speedFaktorUD = 75

local player = {
  posX = 0,
  posY = 0,
  width=0,
  heigth=0,
  sheet=nil,
  anim=nil,
  animSpeed=0.2,
  orientation={true,true,true,true},
  animations = {},
  movementSpeed = 0,
  isMoving = false,
  speed=1
}

local winWidth, winHeight = 0,0

function player.load()
  player.sheet = love.graphics.newImage("assets/characters/player/sheet.png")
  player.width = 48
  player.height = 92

  player.grid = anim8.newGrid(48,92,player.sheet:getWidth(),player.sheet:getHeight())--
  player.animations = {}
  player.animations[0] = anim8.newAnimation(player.grid('1-3',1), player.animSpeed)
  player.animations[1] = anim8.newAnimation(player.grid('1-3',2), player.animSpeed)
  player.animations[2] = anim8.newAnimation(player.grid('1-3',3), player.animSpeed)
  player.animations[3] = anim8.newAnimation(player.grid('1-3',4), player.animSpeed)
  player.anim = player.animations[0]

  winWidth, winHeight = love.graphics.getDimensions()
end

function player.update(dt)
  moveSpeed = player.speed * speedFaktor
  updownSpeed = player.speed * speedFaktorUD

  if love.keyboard.isDown("left") then
    player.posX = player.posX + moveSpeed*dt
    player.isMoving = true
    player.anim = player.animations[0]
  end
  if love.keyboard.isDown("right") then
    player.isMoving = true
    player.anim = player.animations[1]
    player.posX = player.posX - moveSpeed*dt
  end
  if love.keyboard.isDown("up") then
    player.posY = player.posY+(updownSpeed)*dt
    player.isMoving = true
    player.anim = player.animations[2]
  end
  if love.keyboard.isDown("down") then
    player.posY = player.posY-updownSpeed*dt
    player.isMoving = true
    player.anim = player.animations[3]
  end

  if(player.isMoving == false) then
    player.anim:gotoFrame(2)
  else
    player.anim:update(dt)
  end
end

function player.draw(zoom)
  local correctFaktor = 2
  -- _C.pixelSize
  local posX = winWidth/2 - (player.width*correctFaktor*zoom)/2
  local posY = winWidth/2 - (player.height*correctFaktor*zoom)/2

  player.anim:draw(player.sheet,posX,posY,0,zoom,zoom)
end

return player
