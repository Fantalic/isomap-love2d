local uUtils = {}

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
        r = r..key .. ": " .. res .."\n"
      end

      return r .. "}\n"
    elseif(typus == 'function') then
        return "function "
    elseif typus == "userdata" then
      return "userdata"
    else
      return input
    end
  end
  local result =  go(anything)
  print(result)
  return result
end

return uUtils
