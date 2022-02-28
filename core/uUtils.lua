local json = require "lib/dkjson"

local uUtils = {}

function uUtils.round(x)
  if(x+0.5> x+1 ) then
    return x+1
  else
    return math.floor(x)
  end
end
--timerStart = love.timer.getTime()
--timerEnd = love.timer.getTime()
function uUtils.loadFile(path)
  assert(path, "Filename is nil!")
	if not love.filesystem.isFile(path) then
    error("Given filename is not a file! Is it a directory? Does it exist?")
  end
	--Reads file
	mapJson = love.filesystem.read(path)
	--Attempts to decode file
	return json.decode(mapJson)
end

function uUtils.inspect(anything,deepth)
  if(deepth == nil) then deepth = 10 end
  if anything == nil then return "nil" end
  local output = nil

  function go(input,lvl)
    if input == nil then return "nil" end
    --if lvl ~= 0 then io.read() end
    if lvl == deepth then return "end" end
    local typus = type(input)
    if (typus == 'table') then
      if lvl == nil then lvl = 0 end
      local r =  "{\n"
      for key, value in pairs(input) do
        local res = go(value,lvl+1)
        if res ~= nil then
          r = r..key .. ": " .. res .."\n"
        end
      end

      return r .. "}\n"
    elseif(typus == 'function') then
        return "function "
    elseif typus == "userdata" then
      return "userdata"
    elseif typus == "boolean" then
      if input then return "true" else return "false" end
    else
      return input
    end
  end
  local result =  go(anything)
  print(result)
  return result
end

return uUtils
