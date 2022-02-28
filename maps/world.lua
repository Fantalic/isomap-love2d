local utils = require "core/uUtils"
local noise = require "lib/noise"
local forest = require "maps/bioms/forest"
local grassland = require "maps/bioms/grassland"

local bioms = {
  -- "desert",
  -- "mountains",
  -- "swamp",
  -- "city",
  -- "fortres",
  {
    name="forest",
    biom = forest,
    symbol = "f",
    neighborBioms= {"grassland"},
    minPercentage= 10
  },
  {
    name = "grassland",
    biom = grassland,
    symbol= "g",
    neighborBioms= {"forest"},
    minPercentage= 10
  }
  -- forest= 'f',
  -- grassland = "g",
  -- water = "w",
  -- sea = "o",
  -- empty= "e"
}

local world = {
  seed=0,
  size=100,
  map={}
}

function world.getBiomIdx(name)
  for ix = 1, #bioms, 1 do
    if(bioms[ix].name == name) then
      return ix
    end
  end
end

local chanceCounterX = 0
local chanceCounterY = 0

local matrix ={}
local ix,iy = 1 ,1

function world.getChance(m,n )
  chanceCounterX = chanceCounterX + 1
  chanceCounterY = chanceCounterY + 1
  ix = chanceCounterX
  iy = m-chanceCounterY
  if(iy == 0 ) then iy = 1 end
  if(matrix[ix] == nil or ix > #matrix[ix]) then  chanceCounterX = 0 end
  if(matrix[iy] == nil or iy > #matrix[iy]) then  chanceCounterY = 0 end
  if(chanceCounterX == 0  or chanceCounterY == 0 ) then
    matrix = noise.generate(world.seed*os.time(),n)
    return world.getChance(m,n)
  end
  return math.abs(utils.round(m + matrix[ix][iy]*n))
end

function world.getNextBiom(point)
  -- calculate chances of next biom from different params
  local range = 20
  local oldbiomIdx = world.map[point[1]][point[2]]
  if oldbiomIdx == "e" or oldbiomIdx == nil or oldbiomIdx == 0  then
     oldbiomIdx = 1
  end
  print("oldbiomidx")
  print(oldbiomIdx)
  local oldBiom = bioms[oldbiomIdx]
  biomCount = {}
  -- < >
  -- get chance per tile
  local sidx = point[1]-range/2
  for iy = 1, range,1 do
    for ix = 1, range, 1 do
      yIdx = iy + point[1]-range/2
      xIdx = ix + point[1]-range/2
      if world.map[yIdx] ~= nil and world.map[yIdx][xIdx] ~= nil then
        if(biomCount[world.map[yIdx][xIdx]] == nil) then
          biomCount[world.map[yIdx][xIdx]] =  0
        end
        local bIdx = world.map[yIdx][xIdx]
        biomCount[bIdx] = biomCount[bIdx]+1
      end
    end
  end

  local nextBiom = oldbiomIdx
  print("old biom count")
  print(biomCount[oldbiomIdx])
  -- multipli by 4 because of the 4 sectors of a diagramm
  local percentage = (biomCount[oldbiomIdx]*4*100/(range*range))
  print("percentage ")
  print(percentage)
  print(oldBiom)

  if ( percentage > oldBiom.minPercentage) then
    local chance = world.getChance(1,100)
    print("chance")
    print(chance)

    if(chance > percentage ) then
      print("new biom !")
      local bIdx = world.getChance(1,2)
      print(bIdx) --
      nextBiom = world.getBiomIdx(oldBiom.neighborBioms[bIdx])
    end
  end
  return nextBiom
end

function world.load(seed)
  world.seed = seed

  for iy = 1, world.size ,1 do
    world.map[iy] = {}
    for ix = 1, world.size, 1 do
      world.map[iy][ix] = "e" -- empty
    end
  end

-- set startpoints for the spiral
  local biomIdx = world.getChance(1,#bioms)+1
  local center = {world.size/2, world.size/2}
  world.map[center[1]]  [center[2]] = biomIdx
  world.map[center[1]+1][center[2]] = biomIdx
  world.map[center[1]+1][center[2]-1] = biomIdx
  local point = {center[1]+1,center[2]-1}

  --TODO. calculate number of cycle loops before instead of checking for end
  local count =0
  local run = true

  while run do
    biomIdx = world.getNextBiom(point)

    if world.map[point[1]+1]            == nil or
       world.map[point[1]-1]            == nil or
       world.map[point[1]][point[2]+1]  == nil or
       world.map[point[1]][point[2]-1]  == nil
    then
      run = false
    else
      --do clockwise spiral...
      if world.map[point[1]][point[2]+1] ~= "e"  and
         world.map[point[1]-1][point[2]] == "e"
      then
         -- if not empty to the right go up
         point[1] = point[1]-1
      elseif world.map[point[1]+1][point[2]] ~= "e" then
        -- if not empty down, go right
        point[2] = point[2]+1
      elseif world.map[point[1]][point[2]-1] ~= "e" then
        -- if not empty to the left go down
        point[1] = point[1]+1
      elseif world.map[point[1]-1][point[2]] ~= "e" then
        -- if not empty up, go left
        point[2] = point[2]-1
      end


      if world.map[point[1]] ~= nil and world.map[point[1]][point[2]] ~=nil then
        world.map[point[1]][point[2]] =  biomIdx
      else
        run = false
      end

      -- local test = ""
      -- for iy = 1, world.size ,1 do
      --   test = ""
      --   for ix = 1, world.size, 1 do
      --     test  =  test .. " ".. world.map[iy][ix] .." "
      --   end
      --   print(test)
      -- end
      -- io.read()

    end
  end

  local test = ""
  for iy = 1, #world.map ,1 do
    test = ""
    for ix = 1, #world.map[iy], 1 do
      if (world.map[iy][ix] ~= "e") then
        local biom = bioms[world.map[iy][ix]]
        if(biom == nil ) then
          world.map[iy][ix] = 1
        else
          world.map[iy][ix] = biom.symbol
        end
      end
     test  =  test .. " ".. world.map[iy][ix] .." "
    end
    print(test)
  end
  -------------------
end

return world
