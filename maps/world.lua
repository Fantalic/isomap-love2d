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
  size=40,
  map={}
}

function world.getBiomIdx(name)
  for ix = 1, #bioms, 1 do
    if(bioms[ix].name == name) then
      return ix
    end
  end
end

local chanceCounter = 0
function world.getChance(seed,m,n )
  local tSeed = world.seed
  if(seed) then
    seed = (tSeed*world.seed)/(tSeed+world.seed)
  end
  math.randomseed(tSeed)
  return math.random(m, n)
end

function world.getNextBiom(point)
  local range = 20
  local oldbiomIdx = world.map[point[1]][point[2]]
  local oldBiom = bioms[oldbiomIdx]
  biomCount = {}
  -- < >
  local sidx = point[1]-range/2
  for iy = 1, range,1 do
    for ix = 1, range, 1 do
      yIdx = iy + point[1]-range/2
      xIdx = ix + point[1]-range/2
      if world.map[yIdx] ~= nil and world.map[xIdx] ~= nil then
        if(biomCount[world.map[yIdx][xIdx]] == nil) then
          biomCount[world.map[yIdx][xIdx]] =  0
        end
        biomCount[world.map[yIdx][xIdx]] = biomCount[world.map[yIdx][xIdx]]+1
      end
    end
  end

  local nextBiom = oldbiomIdx
  print("count")
  print(biomCount[oldbiomIdx])
  local percentage = (biomCount[oldbiomIdx]*2*100/(range*range))
  print("percentage ")
  print(percentage)

  if (percentage > oldBiom.minPercentage) then
    local chance = world.getChance(os.time()*point[1]*point[2],1,100)
    print("chance")
    print(chance)

    if(chance > percentage ) then
      print("new biom !")
      local bIdx = world.getChance(percentage*chance*biomCount[oldbiomIdx],1,#oldBiom.neighborBioms)
      nextBiom = world.getBiomIdx(oldBiom.neighborBioms[bIdx])
    end
  end
  return nextBiom
end

function world.load(seed)
  world.seed = seed
  math.randomseed(seed)

  for iy = 1, world.size ,1 do
    world.map[iy] = {}
    for ix = 1, world.size, 1 do
      world.map[iy][ix] = "e" -- empty
    end
  end

  local biomIdx = math.random(1,#bioms)
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
    -- test ---
    -- count = count +1
    -- world.map[point[1]][point[2]] = count
    -----
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
  for iy = 1, world.size ,1 do
    test = ""
    for ix = 1, world.size, 1 do
      if (world.map[iy][ix] ~= "e") then
        world.map[iy][ix] = bioms[world.map[iy][ix]].symbol
      end
      test  =  test .. " ".. world.map[iy][ix] .." "
    end
    print(test)
  end
  -------------------
end

return world
