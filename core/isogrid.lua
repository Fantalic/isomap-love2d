local isogrid = {
  pos={x=0,y=0}
}

local grass
local dirt

function isogrid.load()
  grass = love.graphics.newImage("assets/textures/openfield.png")
  dirt  = love.graphics.newImage("assets/textures/GrassTile.png")

  isogrid.block_width = grass:getWidth()
  isogrid.block_height = grass:getHeight()
  isogrid.block_depth = isogrid.block_height / 2

  isogrid.grid_size = 20
  isogrid.grid = {}
  for x = 1,isogrid.grid_size do
     isogrid.grid[x] = {}
     for y = 1,isogrid.grid_size do
        isogrid.grid[x][y] = 1
     end
  end
  -- test
  isogrid.grid[2][4] = 2
  isogrid.grid[6][5] = 2
end

function isogrid.draw()

  for x = 1,isogrid.grid_size do
    for y = 1,isogrid.grid_size do
      local xPos = isogrid.pos.x + ((y-x) * (isogrid.block_width / 2))
      local yPos = isogrid.pos.y + ((x+y) * (isogrid.block_depth / 2)) - (isogrid.block_depth * (isogrid.grid_size / 2))
      if isogrid.grid[x][y] == 1 then
        love.graphics.draw(grass, xPos, yPos )
      else -- isogrid.grid[x][y] == 2
        love.graphics.draw(dirt, xPos, yPos )
      end
    end
  end
end

return isogrid
