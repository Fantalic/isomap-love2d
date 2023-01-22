

local function createGrid(sizeX,sizeY,tileSize)
  local grid = {
    screenPosX=0,screenPosY=0,
    sizeX = sizeX, sizeY = sizeY,
    tileWidth = tileSize, tileHeight = tileSize,
    tWidth = tileSize, tHeight = tileSize,
    pixelGrid = {{}},
    visiblePixels = {}
  }

  function grid:load()
    self.tWidth = self.tileWidth * zoomFactor
    self.tHeight = self.tileHeight * zoomFactor

  end

  function grid:createPixel(x,y,pixel,parent)
    local pixel = {
      parent= parent, -- reference to object fe a Tree
      x,y,
    }

  end

  function grid:placeObject(x,y,object)

  end

  function grid:moveObject()

  end

  return grid
end

return createGrid
