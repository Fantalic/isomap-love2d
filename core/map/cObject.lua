-- basic map object

function new(tx,ty,textureKey)
  -- ty,ty - x,y coordinates on isogrid
  local object = {
    textureKey = textureKey,
    x=tx, y=ty,
    isUpdating=false
  }



  return object

end
