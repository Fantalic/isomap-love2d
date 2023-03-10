button = {}

function GUI:mousereleased(x, y, button, isTouch)
  local point = {x=x,y=y}

  for i = 1, #self.items do
    local item = self.items[i]

    local inBounderies = utils.isPointInBounderies(
      point,
      item.pos,
      item.size
    )

    if(inBounderies) then
      item:onClick()
    elseif(item.active) then
      item:setActive(false)
    end

  end

  -- stops event
  return true
else
  local activeItemClicked = false
  for k,item in pairs(activeItems) do
    print(" - "..k)
    for i = 1, #item.items do
      local item = item.items[i]

      local inBounderies = utils.isPointInBounderies(
          point,
          item.pos,
          item.size
        )

      if(inBounderies) then
        item:onClick()
        activeItemClicked = true
        print("clicked active item")
        --stops event ( undernease clicks not regoniced)
        return true
      elseif(item.active) then
        --item:setActive(false)
      end

    end

    local inBounderies = utils.isPointInBounderies(
        point,
        item.pos,
        item.size
      )

  end

  if( not activeItemClicked ) then
    for k,item in pairs(activeItems) do
      item:setActive(false)
    end
  end
end

return button
