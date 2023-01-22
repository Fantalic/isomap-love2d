-- TODO: create menu with json structure or lua table
local utils = require "core/uUtils"


local activeItems={} -- with item.name as key

local GUI = {
  winSizeX = 0,
  winSizeY = 0,
  sizeX = 40, --equals window length
  sizeY = 40,

  background = "white",
  items= {} --recursive structur; addItem to add to table
}

local winSize = {x=0,y=0}

function createItem(name,color,pos,size)
  -- create newItem, which can create new child item; recursive structure
  local item = {
    name=name,
    trigger="click", -- "hover"; ...
    active=false,
    color= color or {0.5,0.1,0.1},
    size= size or {x=40,y=40},
    pos = pos,
    items={}
  }

  function item:setActive(active)
    self.active = active
    if(active) then
      print("set active ".. self.name)
      activeItems[self.name] = item
    else
      print("remove item "..self.name)
      activeItems[self.name] = nil
    end
  end

  function item:createChild(name,size)
    local pos = {}
    pos.x = self.pos.x
    pos.y = self.pos.y
    --TODO: decide weather to place on Top, right, left or buttom
    -- calculate pos right side of parent
    -- ....
    -- calculate pos on top of parent
    pos.x = pos.x
    pos.y = pos.y - size.y

    local color = {0,0,0}
    color[1] = self.color[1] - 0.1
    color[2] = self.color[2] - 0.1
    color[3] = self.color[3] - 0.1

    local item = createItem(name,color,pos,size)
    table.insert(self.items,item)
  end

  function item:onClick()
    self.active = not self.active
    print(self.name .. " clicked !")
    print("item active : ")
    print(self.active)
    self:setActive(self.active)

  end

  function item:draw()

    love.graphics.setColor(item.color)
    love.graphics.rectangle(
      "fill",
      self.pos.x,self.pos.y, -- pos
      self.size.x, self.size.y -- size
    )

    if(self.active) then
      for i = 1, #self.items do
        local item = self.items[i]
        item:draw()
      end
    end

  end

  return item
end

function GUI:load()

  local x,y = love.graphics.getDimensions( )
  winSize.x = x
  winSize.y = y

  local pos = {x=#self.items*40, y=y-40}
  local item = createItem("build 1",{0.1,0.5,0.9},pos)
  item:createChild("child 1",{x=80,y=160})
  table.insert(self.items,item);


  pos = {x=#self.items*40, y=y-40}
  item = createItem("build 2",{0.1,0.1,0.9},pos)
  item:createChild("child 1",{x=50,y=100})
  table.insert(self.items,item);
end

function GUI:update(dt)

end

function GUI:draw()
  love.graphics.setColor(0.5, 0.5, 0.5)
  love.graphics.rectangle(
    "fill",
    0, winSize.y - self.sizeY,
    winSize.x, self.sizeY
  )
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
