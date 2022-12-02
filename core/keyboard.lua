-- ==============================
-- handles keyboard inputs
-- ==============================

-- default bindings
local bindings = {
    player = {
      moveUp = "w",
      moveDown = "s",
      moveRight = "d",
      moveLeft = "a",
    },

    moveCameraUp = "keyUp",
    moveCameraDown = "keyDown",
    moveCameraRight = "keyRight",
    moveCameraLeft = "keyLeft"
}

-- private variables
local update = false
local pressedKey = nil
local keysPressedCount = 0

-- keyboard object
local keyboard = {
  onKeyInput = {}
}

function keyboard:load()
end

function keyboard:keypressed(key)
  update = true
  keysPressedCount = keysPressedCount + 1

  playerIsMoving = array.contains({"w","a","s","d"},key)
  cameraMoving = array.contains({})
end

function keyboard:keyreleased(key)
  keysPressedCount = keysPressedCount - 1
  if(keysPressedCount == 0 ) then
    update = false
    pressedKey = nil
  end
end

local function checkPlayerMovment(dt)
end

function keyboard:update(dt)
  if (update == true) then
    --onKeyInput(dt)
  end
end

local function onKeyInput(dt)

end

local function  utilMoveMentInput(keyUp,keyDown,keyRight,keyLeft)
  local invert = -1

 -- first animation level :
 local x = 0
 local y = 0
 local direction = "" -- type: ["N","S","W","O","NW","NO","SW","SO"]

  if love.keyboard.isDown("down") then
     y = y-updownSpeed*dt*invert
     direction = "S"
    if love.keyboard.isDown("left") then
      x = x + moveSpeed*dt*invert
      direction = direction .. "W"
    elseif love.keyboard.isDown("right") then
      x = x - moveSpeed*dt*invert
      direction = direction .. "O"
    end

  elseif love.keyboard.isDown("up") then
    y = y+updownSpeed*dt*invert
    direction = "N"
    if love.keyboard.isDown("left") then
      x = x + moveSpeed*dt*invert
      direction = direction .."W"
    elseif love.keyboard.isDown("right") then
      x = x - moveSpeed*dt*invert
      direction = direction.. "O"

  elseif love.keyboard.isDown("left") then
    x = x+ moveSpeed*dt*invert
    direction = "W"
  end

  elseif love.keyboard.isDown("right") then
    x = x - moveSpeed*dt*invert
    direction = "O"
  end

  return {x,y,dir=direction}
end

return keyboard
