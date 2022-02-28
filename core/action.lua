local anim8 = require("lib/anim8/anim8")
local utils = require "core/uUtils"

local action = {}

function action:new(name,speed,gw,gh)
   local a = {}
   setmetatable(a, self)
   self.__index = self
   self.name = name
   local path = "assets/characters/player/" .. name .. "Sheet.png"
   local sheet = love.graphics.newImage(path)
   a.grid = anim8.newGrid(gw,gh,sheet:getWidth(),sheet:getHeight())--
   a.sheet = sheet
   a.speed = speed
   a.anims= {}
   a.activLayers={}

   print("inspect..")
   utils.inspect(a)
   return a
end

function action:addAnims(indecies)
  for idx = 1, #indecies do
  end
end

function action:addAnim(begintoend,row, option)
  local anim = anim8.newAnimation(self.grid(begintoend,row), self.speed,option)
  table.insert(self.anims, anim)
end

function action:setActivLayers(layers) -- layers;Array of number
  self.activLayers = {}
  for idx=1, #layers do
    table.insert(self.activLayers,self.anims[layers[idx]])
    self.activLayers[idx]:resume()
  end
end

function action:gotoFrame(frame)
  for idx=1,#self.activLayers do
    self.activLayers[idx]:gotoFrame(frame)
  end
end

function action:update(dt)
  if self.activLayers ~= nil then
    for idx=1,#self.activLayers do
      self.activLayers[idx]:update(dt)
    end
  end
end

function action:draw(posX, posY,zoom)
  for idx=1,#self.activLayers do
    self.activLayers[idx]:draw(self.sheet,posX,posY,0,zoom,zoom)
  end
end

return action
