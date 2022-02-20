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
  animSpeed=0.1,
  orientation={true,true,true,true},
  animations = {},
  movementSpeed = 0,
  isMoving = false,
  speed=1
}

function player.load()
  player.sheet = love.graphics.newImage("assets/characters/player/sheet.png")
  player.width = 48
  player.height = 96

  player.grid = anim8.newGrid(player.width,player.height,player.sheet:getWidth(),player.sheet:getHeight())--
  player.animations = {}
  player.animations[1] = anim8.newAnimation(player.grid('1-3',1), player.animSpeed)
  player.animations[2] = anim8.newAnimation(player.grid('1-3',2), player.animSpeed)
  player.animations[3] = anim8.newAnimation(player.grid('1-3',3), player.animSpeed)
  player.animations[4] = anim8.newAnimation(player.grid('1-3',4), player.animSpeed)
  player.animations[5] = anim8.newAnimation(player.grid('1-3',5), player.animSpeed)
  player.animations[6] = anim8.newAnimation(player.grid('1-3',6), player.animSpeed)
  player.animations[7] = anim8.newAnimation(player.grid('1-3',7), player.animSpeed)
  player.animations[8] = anim8.newAnimation(player.grid('1-3',8), player.animSpeed)
  player.anim = player.animations[1]

  winWidth, winHeight = love.graphics.getDimensions()
end

function player.update(dt)
  moveSpeed = player.speed * speedFaktor
  updownSpeed = player.speed * speedFaktorUD
  player.isMoving = false

  if love.keyboard.isDown("down") then
    player.posY = player.posY-updownSpeed*dt
    player.isMoving = true
    if     love.keyboard.isDown("left") then
      player.anim = player.animations[2]
      player.posX = player.posX + moveSpeed*dt
    elseif love.keyboard.isDown("right") then
      player.anim = player.animations[8]
      player.posX = player.posX - moveSpeed*dt
    else
      player.anim = player.animations[1]
    end

  elseif love.keyboard.isDown("up") then
    player.posY = player.posY+updownSpeed*dt
    player.isMoving = true
    if     love.keyboard.isDown("left") then
      player.anim = player.animations[4]
      player.posX = player.posX + moveSpeed*dt
    elseif love.keyboard.isDown("right") then
      player.anim = player.animations[6]
      player.posX = player.posX - moveSpeed*dt
    else
      player.anim = player.animations[5]
    end

  elseif love.keyboard.isDown("left") then
    player.posX = player.posX + moveSpeed*dt
    player.isMoving = true
    player.anim = player.animations[3]

  elseif love.keyboard.isDown("right") then
    player.isMoving = true
    player.anim = player.animations[7]
    player.posX = player.posX - moveSpeed*dt
  end

  if(player.isMoving == false) then
    player.anim:gotoFrame(2)
  else
    player.anim:update(dt)
  end
end

function player.draw(zoom)
  local correctFaktor = 1
  -- _C.pixelSize
  posY = love.graphics.getHeight( )/2- (player.width*correctFaktor*zoom)/2
  posX = love.graphics.getWidth( )/2  - (player.height*correctFaktor*zoom)/2

  player.anim:draw(player.sheet,posX,posY,0,zoom*1.5,zoom*1.5)
end

return player
