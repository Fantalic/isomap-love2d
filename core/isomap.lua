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

local zoomL = 1
local zoom = 1
local winWidth, winHeight = love.graphics.getDimensions()

local map = {
  data = {},
	textures = {},
	tileData = {},
	lighting = {},
	zoom = 1,
	offset= {x=0,y=0},
  pos = {x=0,y=0},
  objects={},
  objectDict = {},
  player = nil

}

local tWidth = 0
local tHeight = 0
local blockedTiles  = {}

function map.load(mapname)
	local path = "maps/"..mapname
	map.data = require (path)
	print("loaded map ")
	print(map.data.name)
	map.data.load()
  for colunas in ipairs(map.data.ground) do
		map.tileData[colunas] = {}
		for linhas in ipairs(map.data.ground[colunas]) do
				local xPos = linhas
				local yPos = colunas
				local tKey = map.data.ground[colunas][linhas]
				map.tileData[colunas][linhas] = { {
          textureKey = tKey,
          x=xPos, y=yPos,
          offSetX = 0,
          offSetY = 0,
          height  = 0
        } }
		end
	end
end

function map:update(dt)

  local rate = 0.05*(dt*300)
  zoomL = (1-rate)*zoomL + rate*zoom
  map.zoom = zoomL

  tWidth = (map.data.tileWidth)*zoomL
  tHeight = (map.data.tileHeight)*zoomL
end

function map:draw(player)
  map.pos.x = player.posX
  map.pos.y = player.posY
  player.speed = zoomL * zoomL
  map.player = player

  posY = love.graphics.getHeight( )/2 + (player.height+tHeight)*map.zoom
  posX = love.graphics.getWidth( )/2  + (player.width+tWidth)*map.zoom

  local pos = map.getTileByPos(posX,posY)

  map.player.tPosI = pos.y
  map.player.tPosJ = pos.x-2

  drawTiles()
  --map.drawObjects()
	--map.drawObjects()
end

function map.wheelmoved(x, y)
    if y > 0 then
      zoom = zoom + 0.1
    elseif y < 0 then
      zoom = zoom - 0.1
    end

	if zoom < 0.1 then zoom = 0.1 end
  print("zoom")
  print(zoom)
end


function drawTiles()
   --{x= 2*tWidth,y=tHeight}
  local mOffset = {x=0.25*tWidth, y=0.125*tHeight}
  local windowTileSizeX = 12 *(1/map.zoom)
  local windowTileSizeY = 12*(1/map.zoom)
  local zeroPointX = 256    + tWidth*2
  local zeroPointY = 0--256* 2 + tHeight*2
  -- zoom ausgleich
  --mOffset.x = mOffset.x - (1/map.zoom)*tWidth*4
  --mOffset.y = mOffset.y - (1/map.zoom)*tHeight*2
  local zeroTile = map.getTileByPos(zeroPointX, zeroPointY) -- (map.pos.x,map.pos.y)
  local drawAfterCharakters= {}
  blockedTiles = {}


  function getPos(j,i)
    local yPos = (j) * tWidth
    local xPos = (i) * tHeight
    local xPos, yPos = map.toIso(xPos, yPos)
    return {
      xPos+map.pos.x,--36*(1/map.zoom)*1.5,
      yPos+map.pos.y,--16*(1/map.zoom)*1.5
    }
  end

  local iterateVisibleTiles = function(funcX,funcY)
    for i = zeroTile.y, zeroTile.y + ( windowTileSizeY),1 do
      if map.tileData[i] then
        if(funcY ~=nil) then funcY(i) end
        for j = zeroTile.x,zeroTile.x + (windowTileSizeX),1 do
          if map.tileData[i][j] then
            funcX(i,j)
          end
        end
      end
    end
  end

  local drawGround = function (i,j)
    local tilePos = getPos(i,j)
    local ground = map.tileData[i][j][1]
    local texture = map.data.textures[ground.textureKey]
    assert(texture, "ERROR(isomap.drawTiles-drawGround): texture ".. ground.textureKey .. "  is nil !")

    love.graphics.draw(
      texture,
      tilePos[1]-mOffset.x - ground.offSetX,
      tilePos[2]-mOffset.y - ground.offSetY - ground.height*tHeight,--.x+map.pos.y
      0,
      map.zoom, map.zoom,
      tWidth, tHeight
    )
    -- if i = 1  its the ground. draw grid
    love.graphics.print(
      "x".. j .." y"..i,
      tilePos[1] - mOffset.x- tWidth/2, -- ,
      tilePos[2] - mOffset.y - tHeight/2,
      0
    )
  end

  local drawObjects = function(i,j)
    for idx = 2, #map.tileData[i][j], 1 do
      local obj = map.tileData[i][j][idx]
      if(obj ~= nil )then
        --print((obj.height/map.data.tileHeight))
        table.insert(blockedTiles,{i=i,j=j})
        local tilePos = getPos(i,j)
        local objHeight = tilePos[2]-mOffset.y  - obj.height*tHeight

        local texture = map.data.textures[obj.textureKey]
        love.graphics.draw(
          texture,
          tilePos[1] -mOffset.y - tWidth/2 +(obj.height/map.data.tileHeight) *(tWidth/2), --- obj.offSetY*map.zoom,
          -- tHeight/2 to get global tile offset (? or center) + object height for texture offset  and last for zoom
          tilePos[2]  -mOffset.x  - tHeight/2 +(obj.width/map.data.tileWidth) *(tHeight/2) ,
          0,
          map.zoom, map.zoom,
          obj.width or tWidth, obj.height or tHeight
        )
      end
     end
     if(map.player.tPosI == i and map.player.tPosJ == j) then
       map.player:draw(zoomL)
     end
  end

  iterateVisibleTiles(drawGround)
  iterateVisibleTiles(drawObjects)


  for idx = 1, #drawAfterCharakters, 1 do
    local obj = drawAfterCharakters[idx]
    local tilePos = getPos(obj.tyPos,obj.txPos)
    local texture = map.data.textures[obj.textureKey]
    love.graphics.draw(
      texture,
      tilePos[1]-mOffset.x ,
      tilePos[2]-mOffset.y - obj.height*tHeight,--.x+map.pos.y
      0,
      map.zoom, map.zoom,
      tWidth, tHeight
    )
  end
end

local objId = 0
function map.insertNewObject(txPos,tyPos,textureKey,height,offSetX,offSetY)
  -- adds object infos to tileData
  objId = objId+1
  local object = {
    id = objId,
    txPos=txPos, -- x =j
    tyPos=tyPos, -- y = i
    textureKey=textureKey,
    offSetX=offSetX or 0 ,
    offSetY=offSetY or 0 ,
    height=map.data.objects[textureKey].height,
    width= map.data.objects[textureKey].width,
    collider = map.data.objects[textureKey].collider,
    --flip = map.data.objects[textureKey].flip
  }
  map.objectDict[objId] = object
  if(map.tileData[tyPos] == nil) then map.tileData[tyPos] ={} end
  if(map.tileData[tyPos][txPos] == nil) then map.tileData[tyPos][txPos] ={} end

  if(map.tileData[tyPos] and map.tileData[tyPos][txPos]) then
    local index = #map.tileData[tyPos][txPos]+1
    map.tileData[tyPos][txPos][index] = object
  end
end

function map.getTileCoordinates2D(i, j)
	local xP = map.tileData[i][j].x * (map.data.tileWidth*map.zoom)
	local yP = map.tileData[i][j].y * (map.data.tileWidth*map.zoom)
	xP, yP = map.toIso(xP, yP)
	return xP, yP
end

function map.getTileByPos(x,y)
  if(x == nil or y== nil) then return {0,0} end
  local mapOffset = {x=map.pos.x,y=map.pos.y}
	-- get tile dimension
	local width  = ((map.data.tileWidth)*map.zoom)
	local height = ((map.data.tileHeight)*map.zoom)
	-- subtract offset and divide by tile width
  local mx = (x-mapOffset.x)/width
	local my = (y-mapOffset.y)/width
  -- cartesian to iso pos
	local ix = -(mx/2) + my
	local iy =  (mx/2) + my
	-- round result to get array indexes
	ix = floor(ix)+1
	iy = floor(iy)+1

  -- !!!!!!! TODO: iy +1 .. solve this in draw function with offset somehow...
	return {x=iy,y=ix} -- i, j
end

function map.checkTileCollision(tile,object)
	local width  = (map.data.tileWidth*map.zoom)
	local height = (map.data.tileHeight*map.zoom)
	local dx = Math.abs(x - cellCenterX)
	local dy = Math.abs(y - cellCenterY)

	-- this is how genius math is !  :D
	-- this checks if x,y  is within a tile
	if (dx / (cellWidth * 0.5) + dy  (cellHeight * 0.5) <= 1) then

	end
end

function map:isTileAccesable(posX,posY)
  local accesable =true
  local tile  = map.getTileByPos(posX,posY)
  print("j:"..tile.y .. " i: " ..tile.x)

  for tIdx in pairs(blockedTiles)do
    if(blockedTiles[tIdx].j == tile.x and  blockedTiles[tIdx].i == tile.y) then
      accesable = false
    end
  end
  print(accesable)
  return accesable
end

--This next function had the underscore added to avoid collisions with
--any other possible split function the user may want to use.
function string:split_(sSeparator, nMax, bRegexp)
	assert(sSeparator ~= '')
	assert(nMax == nil or nMax >= 1)

	local aRecord = {}

	if self:len() > 0 then
		local bPlain = not bRegexp
		nMax = nMax or -1

		local nField, nStart = 1, 1
		local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
		while nFirst and nMax ~= 0 do
			aRecord[nField] = self:sub(nStart, nFirst-1)
			nField = nField+1
			nStart = nLast+1
			nFirst,nLast = self:find(sSeparator, nStart, bPlain)
			nMax = nMax-1
		end
		aRecord[nField] = self:sub(nStart)
	end

	return aRecord
  --Credit goes to JoanOrdinas @ lua-users.org
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
		--https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
		--Function "spairs" by Michal Kottman.
end

function floor(x)
	--(><)
	x = math.floor(x)
	if(x < 0 ) then x = x+1 end
	return x
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


function map.removeObject(i,j)

end


-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end



return map
