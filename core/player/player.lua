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
  local bodyAnim = a:addAnim('1-8',1,'pauseAtEnd')
  local armAmin = a:addAnim('1-8',2,'pauseAtEnd')

  -- added a callback to anim8.lua in Animation:pause()
  function onPause(anim)
    anim:resume()
    anim.status = "playing"
    anim:gotoFrame(1)
    self.isMoving = false
  end
  bodyAnim.onPause = onPause
  armAmin.onPause = onPause

  player.actions.grabbing = a

  return player
end

function player:move(dt,dir)
  moveSpeed = self.speed * speedFaktor
  updownSpeed = self.speed * speedFaktorUD

  -- rename to playerisActiv or something
  self.isMoving = true
  self.currentAction = self.actions.walking

  -- first animation level :
  local x = self.posX or 0
  local y = self.posY or 0

  if dir == "N" then
     y = y - updownSpeed*dt
     self.currentAction:setActivLayers({5})
  elseif (dir =="S") then
    y = y + updownSpeed*dt
    self.currentAction:setActivLayers({1})
  elseif ( dir == "W") then
    self.currentAction:setActivLayers({3})
    x = x - moveSpeed*dt
  elseif (dir == "O") then
    self.currentAction:setActivLayers({7})
    x = x + moveSpeed*dt
  elseif (dir == "NW") then
    y = y - updownSpeed*dt
    x = x - moveSpeed*dt
    self.currentAction:setActivLayers({4})
  elseif (dir == "NO") then
    y = y - updownSpeed*dt
    x = x + moveSpeed*dt
    self.currentAction:setActivLayers({6})
  elseif (dir == "SW") then
    y = y + updownSpeed * dt
    x = x - moveSpeed*dt
    self.currentAction:setActivLayers({2})
  elseif (dir == "SO") then
    y = y + updownSpeed * dt
    x = x + moveSpeed*dt
    self.currentAction:setActivLayers({8})
  end

  if(x~=nil and y~=nil and self.isMoving )then
    self.posX = x
    self.posY = y
  end

end

function player:update(dt,map)
  if not self.isMoving and love.keyboard.isDown("e") then
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

function player:draw(x,y,zoom) --zoom
  -- local correctFaktor = 1
  -- -- _C.pixelSize
  -- if(x == nil)then
  --   x = love.graphics.getWidth( )/2
  -- end
  -- if(y== nil )then
  --    y = love.graphics.getHeight( )/2
  -- end
  -- posY = y -- - (self.width*correctFaktor*zoom)/2
  -- posX = x --  - (self.height*correctFaktor*zoom)/2

  self.currentAction:draw(self.posX,self.posY,zoom*1.5,zoom*1.5)
end

function grab()

end

return player
