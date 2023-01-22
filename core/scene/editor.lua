
local createGrid = require ("core/scene/isoGrid")

local editor = {}

local objects = {}
local pixelSize = 5*10
local cube = {texture=nil}
local grid = nil

function editor:load()
  grid = createGrid()
  cube.texture =  love.graphics.newImage("assets/textures/isoCube64x64.png")
end

function editor:draw()
  for idx = 1, #objects, 1 do
    objects[idx]:draw()
  end
end

function editor:drawGround()
  
end


function editor:mousereleased(x, y, button, isTouch)
	-- body...
	clickPosX = x
	clickPosY = y
  local obj = {x=x,y=y}
  function obj:draw()
    love.graphics.setColor({1,1,1,1})
    --love.graphics.polygon("fill", 100,100, 200,100, 150,200)
    --love.graphics.rectangle("fill", x,y, pixelSize, pixelSize)
    --love.graphics.rectangle("fill", x,y, pixelSize*2, pixelSize,45)
    love.graphics.draw(
      cube.texture,
      x,
      y,
      0,
      0.125,0.125
    )

    love.graphics.setColor({1,0,0,1})

  end

  table.insert(objects,obj)

end


return editor
