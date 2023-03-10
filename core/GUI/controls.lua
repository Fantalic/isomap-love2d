
local controls = {}
local activeItems = {} -- with item.name as key

function controls.createItem(name,color,pos,size)
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

  function item:insertItem(item)
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


function controls:newPanel(name,color,pos,size)

  local panel = self.createItem(name,color,pos,size)
  return panel
end

return controls
