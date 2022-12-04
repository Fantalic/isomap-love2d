-- ==============================
-- handles keyboard inputs
-- ==============================

-- keyboard object
local keyboard = {
  bindings = {},  -- holds a control object (TControl) behind the keyboard key as table key
  activeControls = {} -- holds controls currently active
}

function keyboard:load()
end

function keyboard:keypressed(key)
  update = true
  -- holds control object (TControl)
  local control = self.bindings[key]
  if (control ~= nil ) then
    if(control.frozen == false) then
      if(control.active == false) then
        self.activeControls[control.name] = control
      end
      control.active = true;
      control.keysPressedCount = control.keysPressedCount + 1
    end
  end

end

function keyboard:keyreleased(key)
  local control = self.bindings[key]
  if control == nil then return end

  control.keysPressedCount = control.keysPressedCount - 1
  if(control.keysPressedCount == 0 ) then
    control.stop()
    self.activeControls[control.name] = nil
  end
end


function keyboard:update(dt)
  for k, control in pairs(self.activeControls) do
    control:callback(dt)
  end
end

local function onKeyInput(dt)

end


function keyboard:addMovmentControl(name,bindings,callback,stopCb)
  local keys = table.values(bindings)
  local control = {
    name = name,
    bindings = bindings,
    keys = table.values(bindings),
    keysPressedCount = 0,
    frozen = false,
    active = false,
  }
  function control:callback(dt)
    local dir = keyboard.getMovmentDirection(
      self.bindings.up,
      self.bindings.down,
      self.bindings.right,
      self.bindings.left
    )
    callback(dt,dir)
  end
  function control:stop()
    control.active = false;
    if(stopCb ~=nil) then
      stopCb()
    end
  end
  function control:remove()
    for k, v in pairs(bindings) do
      self.bindings[v] = nil
    end
  end

  for k, v in pairs(bindings) do
    self.bindings[v] = control
  end

  return control
end

function keyboard.getMovmentDirection(keyUp,keyDown,keyRight,keyLeft)

 -- first animation level :
 local direction = "" -- type: ["N","S","W","O","NW","NO","SW","SO"]

  if love.keyboard.isDown(keyDown) then
     direction = "S"
    if love.keyboard.isDown(keyLeft) then
      direction = direction .. "W"
    elseif love.keyboard.isDown(keyRight) then
      direction = direction .. "O"
    end

  elseif love.keyboard.isDown(keyUp) then
    direction = "N"
    if love.keyboard.isDown(keyLeft) then
      direction = direction .."W"
    elseif love.keyboard.isDown(keyRight) then
      direction = direction.. "O"
    end

  elseif love.keyboard.isDown(keyLeft) then
    direction = "W"
  elseif love.keyboard.isDown(keyRight) then
    direction = "O"
  end

  return direction
end

return keyboard
