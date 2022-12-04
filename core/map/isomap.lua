--[[MIT License

Copyright (c) 2016 Pedro Polez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]]--

--Links used whilst searching for information on isometric maps:
--http://stackoverflow.com/questions/892811/drawing-isometric-game-worlds
--https://gamedevelopment.tutsplus.com/tutorials/creating-isometric-worlds-a-primer-for-game-developers--gamedev-6511
--Give it a good read if you don't understand whats happening over here.


local json = require("lib/dkjson")
local utils = require "core/uUtils"
local cObject = require("core/map/cObject")
local mapData = require("core/map/mapData")

local winWidth, winHeight = love.graphics.getDimensions()

local map = {
	--public vars
	textures = {},
	data = nil,
	lighting = {},
	offset= {x=0,y=0},
  pos = {x=0,y=0},
  objects={},
  npcs = {},
  objectDict = {},
  player = nil
}
-- private vars
local tWidth = 0  -- tile Width changes by zoom
local tHeight = 0
local windowTileSizeX = 12 -- defines number of drawn tiles
local windowTileSizeY = 12
local zoomFactor = 1

function map:load(mapname)
	local path = "maps/"..mapname
  self.data = require (path)
  self.data:load()
	print("loaded map '".. map.data.name .. "' \n")

	tWidth = (self.data.tileWidth) * zoomFactor
	tHeight = (self.data.tileHeight) * zoomFactor

end

function map:update(dt)

  if(self.player ~= nil) then
    self.player:update(dt)
  end

end

function map:draw(zoom)
  local tiles = map.data.tiles

  local drawGround = function (i,j)
    local tilePos = self:getPos(i,j)
    local ground = self.data.tiles[i][j][1]

    assert(ground.texture, "ERROR(isomap.draw-drawGround): texture ".. ground.textureKey .. "  is nil !")
    love.graphics.draw(
      ground.texture,
      tilePos[1],
      tilePos[2], --.x+map.pos.y
      0,
      zoomFactor, zoomFactor,
      tWidth, tHeight
    )
    -- if i = 1  its the ground. draw grid
    love.graphics.print(
      "x".. j .." y"..i,
      tilePos[1]  + tWidth, -- ,
      tilePos[2]  + tHeight/2,
      0,
      zoomFactor, zoomFactor,
      tWidth, tHeight
    )

  end

  local drawObjects = function(i,j)
    for idx = 2, #self.data.tiles[i][j], 1 do
      local obj = self.data.tiles[i][j][idx]
      if(obj ~= nil ) then
        local tilePos = self:getPos(i,j)
        -- 64*128 textures are basic. all bigger textures must have an offset
        -- in height and width
        local objTileHeight = ((obj.height-map.data.tileHeight) /map.data.tileHeight) * tHeight
        local objTileWidth = (((obj.width)/(map.data.tileWidth*2))-1) * tWidth

        local xPos = tilePos[1] - objTileWidth
        local yPos = tilePos[2] - objTileHeight

				if(obj.textureKey == "tree" and obj.blockedTiles) then
					print(obj.textureKey)
					inspect(obj.blockedTiles)
				end

				if(obj.draw) then
					obj:draw(xPos,yPos,zoomFactor)
				end
      end
     end
  end

  self:iterateVisibleTiles(drawGround)
  self:iterateVisibleTiles(drawObjects)

	local objTileHeight = ((self.player.height /map.data.tileHeight)) * tHeight

	local xPos = self.player.posX + (self.player.width/2)
	local yPos = self.player.posY + objTileHeight + tHeight/2
	love.graphics.setColor({0, 1, 0, 1})
	love.graphics.rectangle("fill", xPos,yPos, 10,10)
	love.graphics.setColor({1, 1, 1, 1})

end

function map:iterateVisibleTiles(funcX,funcY)
	-- get tile from fixed zero point screen position
	local zeroPointX = 256  --  + tWidth*2 --TODO: check this
	local zeroPointY = 0 --256* 2 + tHeight*2
	local zeroTile =  map.getTileByPos(zeroPointX, zeroPointY) -- (map.pos.x,map.pos.y)

  for i = zeroTile.y, zeroTile.y + ( windowTileSizeY),1 do
		if self.data.tiles[i] then
      if(funcY ~=nil) then funcY(i) end -- TODO: usage ?
      for j = zeroTile.x,zeroTile.x + (windowTileSizeX),1 do
        if self.data.tiles[i][j] then
          funcX(i,j)
        end
      end
    end
  end
end

function map:getPos(j,i)
  local mOffset = {x=0.25*tWidth, y=0.125*tHeight}
  -- get screen postions(?) by iso-grid coordinates
  local yPos = (j) * tWidth - tWidth
  local xPos = (i) * tHeight
  local xPos, yPos = map.toIso(xPos, yPos)
  return {
    xPos+self.pos.x - mOffset.x,--36*(1/map.zoom)*1.5,
    yPos+self.pos.y - mOffset.y--16*(1/map.zoom)*1.5
  }
end

function map:zoom(factor)
  zoomFactor = factor
  tWidth = (self.data.tileWidth) * factor
  tHeight = (self.data.tileHeight) * factor
	-- TODO: last change before error
	windowTileSizeX = 12 *(1/factor)
	windowTileSizeY = 12*(1/factor)

  if self.player then
		self.player.speed = zoomFactor * zoomFactor * 2
	end

end

function map:insertPlayer(player)
  self.player = player
  self.player:load()
	self.player.speed = zoomFactor * zoomFactor * 2

  local spawnPoint = {x=5,y=5}

	-- local object = self.data.createEmptyObject(player.width,player.height)
  -- function object:draw(x,y,zoom)
	--
	-- 	player:draw(x,y,zoom)
	-- end

	self.data:insertObject(spawnPoint.x,spawnPoint.y,player)

	--self.player:draw(self.player.posX,self.player.posY,zoomFactor)
end

function map:onCameraMove(dx,dy)
	self.pos.x = self.pos.x + dx
	self.pos.y = self.pos.y + dy

	if(self.player) then
		self.player.posX = self.player.posX + dx
		self.player.posY = self.player.posY + dy

		local objTileHeight = ((self.player.height /map.data.tileHeight)) * tHeight
		local xPos = self.player.posX + (self.player.width/2)
		local yPos = self.player.posY + objTileHeight + tHeight/2

		local tPos = self.getTileByPos(xPos,yPos)
		inspect(tPos)
	end
end

function map:insertNewObject(txPos,tyPos,textureKey)
  -- adds object infos to tileData
  -- textureKey must have been loaded in map.data.object on load

  local object = self.data:createObject(txPos,tyPos,textureKey)

  function object:draw(xPos,yPos)
    local myColor = {0, 1, 0, 1}
    love.graphics.setColor(myColor)

    love.graphics.draw(
      object.texture,
      xPos,
      yPos,
      0,
      zoomFactor, zoomFactor,
      tWidth,tHeight
    )
    love.graphics.setColor({1,1,1,1})
  end

  --self.data:insertObject(txPos,tyPos,object)

end

function map.getTileCoordinates2D(i, j)
	local xP = self.data.tiles[i][j].x * (map.data.tileWidth*zoomFactor)
	local yP = self.data.tiles[i][j].y * (map.data.tileWidth*zoomFactor)
	xP, yP = map.toIso(xP, yP)
	return xP, yP
end

function map.getTileByPos(x,y)
  if(x == nil or y== nil) then return {0,0} end
  local mapOffset = {x=map.pos.x,y=map.pos.y}
	-- subtract offset and divide by tile width
  local mx = (x-mapOffset.x)
	local my = (y-mapOffset.y)

  -- cartesian to iso pos
	local ix = (-(mx/2) + my) / (tWidth) - 0.4
	local iy =  ((mx/2) + my) / (tHeight) - 0.25

	-- round result to get array indexes
	ix = math.floor(ix+0.5) + 2
	iy = math.floor(iy+0.5) + 1

	if(ix <= 0 ) then
		ix = 1
		--return nil
  elseif(iy <= 0) then
		iy= 1
		 --return nil
	  end
	return {x=iy,y=ix} -- i, j
end

function map.checkTileCollision(tile,object)
	local width  = (map.data.tileWidth*zoomFactor)
	local height = (map.data.tileHeight*zoomFactor)
	local dx = Math.abs(x - cellCenterX)
	local dy = Math.abs(y - cellCenterY)

	-- this is how genius math is !  :D
	-- this checks if x,y  is within a tile
	if (dx / (cellWidth * 0.5) + dy  (cellHeight * 0.5) <= 1) then

	end
end

function map.toIso(x, y)
	assert(x, "Position X is nil!")
	assert(y, "Position Y is nil!")

	newX = x-y
	newY = (x + y)/2
	return newX, newY
end

function map.toCartesian(x, y)
	assert(x, "Position X is nil!")
	assert(y, "Position Y is nil!")
	x = (2 * y + x)/2
	y = (2 * y - x)/2
	return x, y
end

return map



-- function map:isTileAccesable(posX,posY)
--   local accesable =true
--   local tile  = map.getTileByPos(posX,posY)
--   print("j:"..tile.y .. " i: " ..tile.x)
--
--   for tIdx in pairs(blockedTiles)do
--     if(blockedTiles[tIdx].j == tile.x and  blockedTiles[tIdx].i == tile.y) then
--       accesable = false
--     end
--   end
--   print(accesable)
--   return accesable
-- end


--
-- --This next function had the underscore added to avoid collisions with
-- --any other possible split function the user may want to use.
-- function string:split_(sSeparator, nMax, bRegexp)
-- 	assert(sSeparator ~= '')
-- 	assert(nMax == nil or nMax >= 1)
--
-- 	local aRecord = {}
--
-- 	if self:len() > 0 then
-- 		local bPlain = not bRegexp
-- 		nMax = nMax or -1
--
-- 		local nField, nStart = 1, 1
-- 		local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
-- 		while nFirst and nMax ~= 0 do
-- 			aRecord[nField] = self:sub(nStart, nFirst-1)
-- 			nField = nField+1
-- 			nStart = nLast+1
-- 			nFirst,nLast = self:find(sSeparator, nStart, bPlain)
-- 			nMax = nMax-1
-- 		end
-- 		aRecord[nField] = self:sub(nStart)
-- 	end
--
-- 	return aRecord
--   --Credit goes to JoanOrdinas @ lua-users.org
-- end


--
-- function spairs(t, order)
--     -- collect the keys
--     local keys = {}
--     for k in pairs(t) do keys[#keys+1] = k end
--
--     -- if order function given, sort by it by passing the table and keys a, b,
--     -- otherwise just sort the keys
--     if order then
--         table.sort(keys, function(a,b) return order(t, a, b) end)
--     else
--         table.sort(keys)
--     end
--
--     -- return the iterator function
--     local i = 0
--     return function()
--         i = i + 1
--         if keys[i] then
--             return keys[i], t[keys[i]]
--         end
--     end
-- 		--https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
-- 		--Function "spairs" by Michal Kottman.
-- end

-- -- Collision detection function;
-- -- Returns true if two boxes overlap, false if they don't;
-- -- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- -- x2,y2,w2 & h2 are the same, but for the second box.
-- function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
--   return x1 < x2+w2 and
--          x2 < x1+w1 and
--          y1 < y2+h2 and
--          y2 < y1+h1
-- end


--
-- function map.drawRect(txPos,tyPos)
--   -- objId = objId+1
--   -- local object = {
--   --   id = objId,
--   --   txPos=txPos, -- x =j
--   --   tyPos=tyPos, -- y = i
--   --   textureKey=textureKey,
--   --   offSetX=offSetX or 0 ,
--   --   offSetY=offSetY or 0 ,
--   --   height=map.data.objects[textureKey].height,
--   --   width= map.data.objects[textureKey].width,
--   --   collider = map.data.objects[textureKey].collider,
--   --   --flip = map.data.objects[textureKey].flip
--   -- }
-- end
