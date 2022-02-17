local forest = {
  seed=603020305,
  mapcolor = "darkgreen",
  minPercent = 10,
  maxPercent = 100,
  symbol = "f",
  neighborBioms= {
    "g"
  }
}

function forest:createWorld()

end

function forest:getBiomChance(map,point)
  local range = 100
  biomCount = {}
  -- < >
  local sidx = point[1]-range/2
  for iy = 1, point[1]-range/2 ,1 do
    for ix = 1, point[2]-range/2, 1 do
      if(biomCount[self.map[iy][ix]] == nil) then
        biomCount[self.map[iy][ix]] =  0
      end
      biomCount[self.map[iy][ix]] = biomCount[self.map[iy][ix]]+1
    end
  end

  local nextBiom = "f"
  local percentage = biomCount/(range*range)
  if (percentage > minPercent) then
    math.randomseed(percentage)
    local chance = math.random(1, 100)
    if(chance >percentage ) then
      math.randomseed(percentage)
      local bIdx = math.random(1,#neighborBioms)
      nextBiom = neighborBioms[bIdx]
    end
  end
  return nextBiom
end

return forest
