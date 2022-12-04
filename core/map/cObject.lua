-- basic map object
local objId = 0

local cObject = {}

function cObject.new(tx,ty,width,height)
  objId = objId+1
  -- ty,ty - x,y coordinates on isogrid
  local object = {
    txPos=tx, tyPos=ty,
    width=width,height=height,
    isUpdating=false,
    id = objId,
    isActive=false
  }

  function object:update(dt)
    if(self.isActive)then
    end
  end

  return object
end

return cObject
