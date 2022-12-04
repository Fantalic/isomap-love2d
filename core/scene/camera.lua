local camera = {
  zoom=1,
  posX=0,posY=0,
  moveSpeed = 0.75
}

function camera:wheelmoved(x, y)
    if y > 0 then
      self.zoom = self.zoom + 0.1
    elseif y < 0 then
      self.zoom = self.zoom - 0.1
    end

	if self.zoom < 0.1 then self.zoom = 0.1 end
end

function camera:move(dt,dir)
  local x = self.posX or 0
  local y = self.posY or 0
  local moveSpeed = self.moveSpeed

  print(dir)
  if dir == "N" then
     y = y + moveSpeed
  elseif (dir =="S") then
    y = y - moveSpeed
  elseif ( dir == "W") then
    x = x + moveSpeed
  elseif (dir == "O") then
    x = x - moveSpeed
  elseif (dir == "NW") then
    y = y + moveSpeed
    x = x + moveSpeed
  elseif (dir == "NO") then
    y = y + moveSpeed*dt
    x = x - moveSpeed*dt
  elseif (dir == "SW") then
    y = y - moveSpeed
    x = x + moveSpeed
  elseif (dir == "SO") then
    y = y - moveSpeed
    x = x - moveSpeed
  end

  local dx = x - self.posX
  local dy = y - self.posY
  self.posX = x
  self.posY = y

  return dx,dy
end

return camera
