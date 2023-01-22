local tileTypes = require "maps/BasicTileTypes"
local utils = require("core/uUtils")

local map = {
  name = "Simple road",
  lighting="255|255|255",
  sizeX = 30,
  sizeY = 30,
  tileWidth = 64,
  tileHeight =64,
  tiles = {},
  objects = {}
}

local textures = {}
local jsonData = {}

function map:load()
  local count = 0
  jsonData = utils.loadFile("maps/test/mapData.json")
  print("files:")
  for key, data in pairs(jsonData) do
    textures[key] = love.graphics.newImage("assets/textures/"..data.file)
    -- if(data.collider) then
    --   map.objects[key].collider = love.image.newImageData("assets/textures/"..data.collider)
    -- end
  end
  self:generate()
end

function map:createEmptyObject(width,height)
  return {
    blocked=false,
    width=width,
    height=heigth
  }
end

function map:insertTexture(tKey,ix,iy)
  if (map.tiles[iy] == nil ) then
    map.tiles[iy] = {}
  end
  if(map.tiles[iy][ix] == nil ) then
    map.tiles[iy][ix] = {}
  end

  local level = #map.tiles[iy][ix]+1
  object = {
    textureKey = tKey,
    texture = textures[tKey] or nil,
    x=ix, y=iy,
    level = level,
    blocked=false,
    width = textures[tKey]:getWidth(),
    height = textures[tKey]:getHeight()
  }
  table.merge(object,jsonData[tKey])

  if(jsonData[tKey].blockedTiles) then
    for idx = 1, #jsonData[tKey].blockedTiles ,1 do
      local pos = jsonData[tKey].blockedTiles[idx]
      local tileData = map.tiles[iy-pos[1]][ix-pos[2]]
      if(tileData and tileData[1]) then
        map.tiles[iy-pos[1]][ix-pos[2]][1].blocked = true
      end
    end
  end

   map.tiles[iy][ix][level] = object
  return object
end

function map:createObject(ix,iy,tKey)
  local object = self:insertTexture(tKey,ix,iy)
  object.id = #self.objects + 1

  table.insert(self.objects, object)
  return object
end

function map:insertObject(ix,iy,object,level)
  if (map.tiles[iy] == nil ) then
    map.tiles[iy] = {}
  end
  if(map.tiles[iy][ix] == nil ) then
    map.tiles[iy][ix] = {{}}
  end

  if(level == nil ) then
    level = #map.tiles[iy][ix]+1
  end

  object.id = #map.objects + 1
  object.blocked = true
  object.level = level

  -- make room to insert object
  if(map.tiles[iy][ix][level]) then
    map.tiles[iy][ix][#map.tiles[iy][ix]+1] = {}
    for i = level, #map.tiles[iy][ix],1 do
      local obj = map.tiles[iy][ix][i]
      map.tiles[iy][ix][i] = nil
      map.tiles[iy][ix][i+1] = obj
    end
  end

  map.tiles[iy][ix][level] = object

  table.insert(self.objects, object)

  return object
end

function map:generate()
  -- ground
  local tKey = "grass"
  for iy = 1, map.sizeY ,1 do
    for ix = 1, map.sizeX,1 do
      self:insertTexture(tKey,ix,iy)
    end
  end
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

  self:insertTexture(road,startPoint[2],startPoint[1])

  road = roadXForward
  local roadEndIdx = math.random(1,map.sizeX)
  if roadEndAxis == 1 then
    road = roadYForward
    roadEndIdx = math.random(1,map.sizeY)
  end
  endPoint[roadEndAxis] = roadEndIdx

  self:insertTexture(road,endPoint[2],endPoint[1])

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
        self:insertTexture(roadYForward,nextPoint[2],nextPoint[1])
      else
        self:insertTexture(roadXForward,nextPoint[2],nextPoint[1])
      end
    end
  end
end


return map
