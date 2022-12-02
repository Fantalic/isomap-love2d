--TODO: try typing with tl https://github.com/teal-language/tl

function move(objMoving,dt,keyDown,keyUp,keyRight,keyLeft)
  -- objMoving: TObject (basic map scene object) ()

  moveSpeed = self.speed * speedFaktor
  updownSpeed = self.speed * speedFaktorUD

  local invert = -1

  objMoving.isMoving = false

 -- first animation level :
 local x = self.posX or 0
 local y = self.posY or 0
  if love.keyboard.isDown("down") then
    self.isMoving = true
    self.currentAction = self.actions.walking
     y = y-updownSpeed*dt*invert
    if     love.keyboard.isDown("left") then
      self.currentAction:setActivLayers({2})
      x = x + moveSpeed*dt*invert
    elseif love.keyboard.isDown("right") then
      self.currentAction:setActivLayers({8})
      x = x - moveSpeed*dt*invert
    else
      self.currentAction:setActivLayers({1})
    end

  elseif love.keyboard.isDown("up") then
    self.isMoving = true
    self.currentAction = self.actions.walking

    y = y+updownSpeed*dt*invert
    if     love.keyboard.isDown("left") then
      self.currentAction:setActivLayers({4})
      x = x + moveSpeed*dt*invert
    elseif love.keyboard.isDown("right") then
      self.currentAction:setActivLayers({6})
      x = x - moveSpeed*dt*invert
    else
      self.currentAction:setActivLayers({5})
    end

  elseif love.keyboard.isDown("left") then
    self.isMoving = true
    self.currentAction = self.actions.walking
    self.currentAction:setActivLayers({3})
    x = x+ moveSpeed*dt*invert

  elseif love.keyboard.isDown("right") then
    self.isMoving = true
    self.currentAction = self.actions.walking
    self.currentAction:setActivLayers({7})
    x = x - moveSpeed*dt*invert
  end

  if(x~=nil and y~=nil and self.isMoving )then
    self.posX = x
    self.posY = y
  end

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
