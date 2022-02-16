local json = require("dkjson")
local testmap =  require "/maps/testmap"

testmap.generate()

for iy = 1, testmap.sizeY ,1 do
  local str = json.encode (testmap.ground[iy], { indent = true })
  print(str)
end
