local _C = require("constants")
local action = require "core/action"

winWidth, winHeight = love.graphics.getDimensions()
local   speedFaktor = 150
local   speedFaktorUD = 75
local quard = 16
local player = {
  posX = 0,
  posY = 0,
  width=quard*3,
  height=quard*6,
  actions = {
    walking = nil,
    grabbing=nil
  },
  anims={{},{},{}}, -- more level; first idle,walking,.. second grabbing.. holding items, third effects.. like sick.. or motivated
  animSpeed=0.1,
  orientation={true,true,true,true},
  movementSpeed = 0,
  isMoving = false,
  speed=1,
  runActionAnim = false
}

function player:load()
  local a = action:new("walking",player.animSpeed,quard*3,quard*6)
  -- a:addAnims({3,5,3,3,3,3,3,5})
  a:addAnim('1-3',1)
  a:addAnim('1-5',2)
  a:addAnim('1-3',3)
  a:addAnim('1-3',4)
  a:addAnim('1-3',5)
  a:addAnim('1-3',6)
  a:addAnim('1-3',7)
  a:addAnim('1-5',8)

  player.actions.walking = a
  player.currentAction = a

  a = action:new("grabbing",player.animSpeed,quard*4,quard*6)
  a:addAnim('1-8',1,'pauseAtEnd')
  a:addAnim('1-8',2,'pauseAtEnd')

  player.actions.grabbing = a

  return player
end


function player:update(dt)
  moveSpeed = self.speed * speedFaktor
  updownSpeed = self.speed * speedFaktorUD
  self.isMoving = false

 -- first animation level :
  if love.keyboard.isDown("down") then
    self.currentAction = self.actions.walking

    self.posY = self.posY-updownSpeed*dt
    self.isMoving = true
    if     love.keyboard.isDown("left") then
      self.currentAction:setActivLayers({2})
      self.posX = self.posX + moveSpeed*dt
    elseif love.keyboard.isDown("right") then
      self.currentAction:setActivLayers({8})
      self.posX = self.posX - moveSpeed*dt
    else
      self.currentAction:setActivLayers({1})
    end

  elseif love.keyboard.isDown("up") then
    self.currentAction = self.actions.walking

    self.posY = self.posY+updownSpeed*dt
    self.isMoving = true
    if     love.keyboard.isDown("left") then
      self.currentAction:setActivLayers({4})
      self.posX = self.posX + moveSpeed*dt
    elseif love.keyboard.isDown("right") then
      self.currentAction:setActivLayers({6})
      self.posX = self.posX - moveSpeed*dt
    else
      self.currentAction:setActivLayers({5})
    end

  elseif love.keyboard.isDown("left") then
    self.currentAction = self.actions.walking

    self.posX = self.posX + moveSpeed*dt
    self.isMoving = true
    self.currentAction:setActivLayers({3})

  elseif love.keyboard.isDown("right") then
    self.currentAction = self.actions.walking

    self.isMoving = true
    self.currentAction:setActivLayers({7})
    self.posX = self.posX - moveSpeed*dt

  elseif love.keyboard.isDown("e") then
    self.currentAction = self.actions.grabbing
    --local b = a:clone():flipV()
    self.currentAction:setActivLayers({1,2})
    self.isMoving = true
  end

  if(self.isMoving == false) then
      self.currentAction:gotoFrame(1)
  else
    self.currentAction:update(dt)
  end

  -- local id = spriteBatch:add(animation:getFrameInfo(x,y,r,sx,sy,ox,oy,kx,ky))
  -- spriteBatch:set(id, animation:getFrameInfo(x,y,r,sx,sy,ox,oy,kx,ky))
end

function player:draw(zoom)
  local correctFaktor = 1
  -- _C.pixelSize
  posY = love.graphics.getHeight( )/2 - (self.width*correctFaktor*zoom)/2
  posX = love.graphics.getWidth( )/2  - (self.height*correctFaktor*zoom)/2

  self.currentAction:draw(posX,posY,zoom*1.5,zoom*1.5)
end

function grab()

end

return player
