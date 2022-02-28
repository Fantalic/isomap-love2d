local noise = require "noise"

local matrix = {}
function love.load(  )
    love.window.setMode(500, 500)
    matrix = noise.generate(os.time(),500)
end

function love.update( dt )

end

function love.draw(  )

  for i=1,#matrix do
    for j=1,#matrix[i] do
      love.graphics.setColor(matrix[i][j], matrix[i][j], matrix[i][j])
      love.graphics.rectangle("fill", 5*(i-1), 5*(j-1), 5, 5)
    end
  end
end
