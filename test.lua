local json = require("dkjson")
local world =  require "/maps/world"

world.load(3423450345)

for iy = 1, world.size ,1 do
  local str = json.encode (world.map[iy], { indent = true })
  print(str)
end
