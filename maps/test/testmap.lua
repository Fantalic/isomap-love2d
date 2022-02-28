local tileTypes = require "maps/BasicTileTypes"
local utils = require("core/uUtils")

local map = {
  name = "Simple road",
  version="v0.1",
  lighting="255|255|255",
  sizeX = 30,
  sizeY = 30,
  tileWidth = 64,
  tileHeight =64,
  ground= {},
  objects = {},
  textures = {}
}

function map.generate()

  map.ground = {}
  -- ground
  local grass = "grass"
  for iy = 1, map.sizeY ,1 do
    map.ground[iy] = {}
    for ix = 1, map.sizeX,1 do
      map.ground[iy][ix] = grass
    end
  end
  print(#map.ground)
  -- place road
  math.randomseed(os.time())
  local roadStartAxis = math.random(1,2)
  local roadEndAxis = math.random(1,2)
  local roadXForward = "road"
  local roadYForward = "roadV"
  local startPoint = {1,1}
  local endPoint = {map.sizeY,map.sizeX}

  math.randomseed(os.time()*2)
  local road = roadXForward
  local roadStartIdx = math.random(1, map.sizeX)
  if roadStartAxis == 1 then
    road = roadYForward
    roadStartIdx = math.random(1, map.sizeY)
  end
  startPoint[roadStartAxis] = roadStartIdx
  map.ground[startPoint[1]][startPoint[2]] = road

  road = roadXForward
  local roadEndIdx = math.random(1,map.sizeX)
  if roadEndAxis == 1 then
    road = roadYForward
    roadEndIdx = math.random(1,map.sizeY)
  end
  endPoint[roadEndAxis] = roadEndIdx

  map.ground[endPoint[1]][endPoint[2]] = road

  local nextPoint = startPoint
  local endReached = false

  local count =2
  while endReached == false do
    count = count *count

    local delta = {
      endPoint[1] - nextPoint[1],
      endPoint[2] - nextPoint[2]
    }
    local axis = 1
    if delta[1] ~= 0 and delta[2] ~= 0 then
      local seed = math.floor(os.time()/count)
      math.randomseed(seed)
      axis = math.random(1,1000)
      if(axis >= 500 ) then axis = 2 else axis = 1 end
    elseif delta[1] == 0 and delta[2] == 0 then
      endReached = true
    elseif delta[1] ~= 0 then
      axis = 1
    elseif delta[2] ~= 0 then
      axis = 2
    end

    if endReached == false then
      nextPoint[axis] = nextPoint[axis] + (delta[axis]/math.abs(delta[axis]))
      --choose texture to place
      if axis == 1 then
        map.ground[nextPoint[1]][nextPoint[2]] = roadYForward
      else
        map.ground[nextPoint[1]][nextPoint[2]] = roadXForward
      end
    end
  end
end

function map.load()
  local count = 0
  local mapData = utils.loadFile("maps/test/mapData.json")
  print("files:")
  for key, data in pairs(mapData) do
    map.textures[key] = love.graphics.newImage("assets/textures/"..data.file)
    map.objects[key] = {
      textureKey = key,
      flip = data.flip,-- tileheight
      width = map.textures[key]:getWidth(),
      height = map.textures[key]:getHeight()
    }
    if(data.collider) then
      map.objects[key].collider = love.image.newImageData("assets/textures/"..data.collider)
    end
  end
  map.generate()
end

return map
