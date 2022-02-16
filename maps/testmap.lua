local tileTypes = require "maps/BasicTileTypes"

local map = {
name = "Simple road",
version="v0.1",
lighting="255|255|255",
sizeX = 30,
sizeY = 30,
tileWidth = 0,
tileHeight = 0,

textures = {},

groundTiles= {
  grass= {
    file= "ls.png",
    type= tileTypes.grass
  },
	road = {
		file= "rd.png",
    type = tileTypes.road
	},
  roadV={
    file="rdv.png",
    type = tileTypes.road
  },
	roadL={
		file="rdl.png",
    type = tileTypes.road
	},
	roadR={
		file="rdr.png",
    type = tileTypes.road
	},
	roadD={
		file="rdrd.png",
    type = tileTypes.road
	},
	water={
		file="water.png",
    type = tileTypes.water
	}
},

objects={
	{
		file= "pixelTree.png",
		mnemonic= "tree",
		origin= "72|245"
	},
	{
		file="praca.png",
		mnemonic="post",
		origin="15|65"
	}
},
ground= {
    	{"water","water","water","water","water","water","water","water","water","water","water","water","water","water","water"},
    	{"grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass"},
    	{"grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass","grass"},
    	{"grass","grass","roadD","road", "road",  "road", "road", "road", "road", "road" ,"road", "roadR","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"},
    	{"grass","grass","roadV","grass","grass","grass","grass","grass","grass","grass","grass","roadV","grass","grass","grass"}
  }
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
  count = 0
  for key, texture in pairs(map.groundTiles) do
    --TODO: set fix width and height
    count = count +1
    map.textures[key] = love.graphics.newImage("assets/textures/"..texture.file)
    if count == 1 then
      map.tileWidth = map.textures[key]:getWidth()/2
      map.tileHeight = map.textures[key]:getHeight()/2
    end
  end
  map.generate()
end

return map
