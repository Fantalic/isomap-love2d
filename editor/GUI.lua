-- TODO: create menu with json structure or lua table
local utils = require "core/uUtils"
local GUIcontrols = require "core/GUI/controls"

function create(color,pos,size)
  local panel = GUIcontrols:newPanel("main",color,pos,size)
  local GUI = {
    items = { panel } --recursive structur; addItem to add to table
  }

  function GUI:load()
    print("load gui")
    print(#self.items)
    -- local pos = {x=#self.items*40, y=y-40}
    -- local item = createItem("build 1",{0.1,0.5,0.9},pos)
    -- item:createChild("child 1",{x=80,y=160})
    -- table.insert(self.items,item);
    --
    --
    -- pos = {x=#self.items*40, y=y-40}
    -- item = createItem("build 2",{0.1,0.1,0.9},pos)
    -- item:createChild("child 1",{x=50,y=100})
    -- table.insert(self.items,item);
  end

  function GUI:update(dt)

  end

  function GUI:draw()
    --mainPanel:draw()
    for i = 1, #self.items do
      local item = self.items[i]
      item:draw()
    end
    love.graphics.setColor(1, 1, 1)
  end

  function GUI:mousereleased(x, y, button, isTouch)
    local point = {x=x,y=y}

    if(y > winSize.y - self.sizeY  ) then  -- click on the main menu
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
    --love.event.quit()
  end

  function GUI:wheelmoved(x, y)
  end

  function GUI:keypressed(key, scancode, isrepeat)
  end

  function GUI:keyreleased(key)

  end

  return GUI
end

return create
