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

local json = require("dkjson")
local utils = require "core/uUtils"
--TODO: Load dkjson relative to mapDecoder's path.


local map = {
  data = {},
	textures = {},
	tileData = {
		width=0,
		height=0
	},
	lighting = {},
	zoomLevel = 1,
	offset= {x=0,y=0}
}

function map.load(mapname)
	local path = "maps/"..mapname
	-- if not love.filesystem.isFile(path) then
	-- 	error("Given mapname is not a file! Is it a directory? Does it exist?")
	-- end

	map.data = require (path)
	print("loaded map ")
	print(map.data.name)
	map.data.load()
end

--TODO: only draw, what is shown
function map.generatePlayField()
	--Add each ground tile to a table according to their texture
	--TODO: the following should be done on a separate thread. I have not tested the performance of the following lines on a colossal map.


	for colunas in ipairs(map.data.ground) do
		map.tileData[colunas] = {}
		for linhas in ipairs(map.data.ground[colunas]) do
				local xPos = linhas
				local yPos = colunas
				local tKey = map.data.ground[colunas][linhas]
				map.tileData[colunas][linhas] = { textureKey = tKey, x=xPos, y=yPos }
		end
	end
		utils.inspect(map.tileData)
end

function map.drawGround(xOff, yOff, size)
	zoomLevel = size
	mapOffset = {x=xOff,y=yOff}
	--Apply lighting
	--love.graphics.setColor(tonumber(mapLighting[1]), tonumber(mapLighting[2]), tonumber(mapLighting[3]), 255)

	for i in ipairs(map.tileData) do
		for j=1,#map.tileData[i], 1 do
			local xPos = map.tileData[i][j].x * (map.data.tileWidth*zoomLevel)
			local yPos = map.tileData[i][j].y * (map.data.tileWidth*zoomLevel)
			local xPos, yPos = map.toIso(xPos, yPos)

			local texture = map.data.textures[map.tileData[i][j].textureKey]
			love.graphics.draw(
			  texture,
				xPos+xOff, yPos+yOff-(map.data.tileWidth/4),
				0,
				size, size,
				map.data.tileWidth,map.data.tileHeight
			)
			love.graphics.print(
			  "x".. i .." y"..j,
				xPos+xOff-map.data.tileWidth/2,
				yPos+yOff-map.data.tileWidth/2
			)
		end
	end
end

function map.drawObjects(xOff, yOff, size)
	--Figure out dynamic object collision
	-- if #mapPropsfield > objectListSize then
	-- 	for i=objectListSize+1, #mapPropsfield do
	-- 		for j=1, objectListSize do
	-- 			if CheckCollision(mapPropsfield[j].colX, mapPropsfield[j].colY, mapPropsfield[j].width, mapPropsfield[j].height, mapPropsfield[i].colX, mapPropsfield[i].colY, mapPropsfield[i].width, mapPropsfield[i].height) and mapPropsfield[i].y < mapPropsfield[j].y and mapPropsfield[i].x < mapPropsfield[j].x then
	-- 				mapPropsfield[j].alpha = true
	-- 			end
	-- 		end
	-- 	end
	-- end
	--
	-- --Sort ZBuffer and draw objects.
	-- for k,v in spairs(mapPropsfield, function(t,a,b) return t[b].mapY > t[a].mapY end) do
	-- 	local xPos = v.x * (map.data.tileWidth*zoomLevel)
	-- 	local yPos = v.y * (map.data.tileWidth*zoomLevel)
	-- 	local xPos, yPos = map.toIso(xPos, yPos)
	--
	-- 	-- if v.alpha then
	-- 	--love.graphics.setColor(255, 255, 255, 90)
	-- 	-- else
	-- 	-- 	love.graphics.setColor(255, 255, 255, 255)
	-- 	-- end
	-- 	love.graphics.draw(v.texture, xPos+xOff, yPos+yOff-(map.data.tileWidth/4), 0, size, size, v.offX, v.offY)
	--
	-- 	--Update values in order to minimize for loops
	-- 	v.alpha = false
	-- 	v.colX = xPos-v.offX
	-- 	v.colY = yPos-v.offY
	-- 	v.mapX, v.mapY = map.toIso(v.x, v.y)
	-- end
end

function map.getTileCoordinates2D(i, j)
	local xP = map.tileData[i][j].x * (map.data.tileWidth*zoomLevel)
	local yP = map.tileData[i][j].y * (map.data.tileWidth*zoomLevel)
	xP, yP = map.toIso(xP, yP)
	return xP, yP
end

--Links used whilst searching for information on isometric maps:
--http://stackoverflow.com/questions/892811/drawing-isometric-game-worlds
--https://gamedevelopment.tutsplus.com/tutorials/creating-isometric-worlds-a-primer-for-game-developers--gamedev-6511
--Give it a good read if you don't understand whats happening over here.

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

function map.insertNewObject(textureI, isoX, isoY, offXR, offYR)
	--User checks
	if offXR == nil then offXR = 0 end
	if offYR == nil then offYR = 0 end
	assert(textureI, "Invalid texture file for object!")
	assert(isoX, "No X position for object! (Isometric coordinates)")
	assert(isoY, "No Y position for object! (Isometric coordinates)")
	assert(mapPlayfieldWidthInTiles>=isoX, "Insertion coordinates out of map bounds! (X)")
	assert(mapPlayfieldWidthInTiles>=isoY, "Insertion coordinates out of map bounds! (Y)")
	local rx, ry = map.toIso(isoX, isoY)

	local colX = isoX * (map.data.tileWidth*zoomLevel)
	local colY = isoY * (map.data.tileWidth*zoomLevel)
	colX, colY = map.toIso(colX, colY)
	--Insert object on map
	table.insert(
	  mapPropsdfield,
		{
			texture=textureI,
			x=isoY,
			y=isoX+0.001,
			offX=offXR,
			offY = offYR,
			mapY = ry,
			mapX = rx,
			colX = colX,
			colY = colY,
			width = textureI:getWidth(),
			height = textureI:getHeight(),
			alpha = false
		}
	)

end

function map.removeObject(x, y)
	if #map.tileData[x][y] > 1 then
		table.remove(map.tileData[x][y], #map.tileData[x][y])
	end
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

function floor(x)
	--(><)
	x = math.floor(x)
	if(x < 0 ) then x = x+1 end
	return x
end

function map.getTileByPos(x,y)
	-- get tile dimension
	local width  = ((map.data.tileWidth)*zoomLevel)
	local height = ((map.data.tileHeight)*zoomLevel)
	-- subtract offset and divide by tile width
  local mx = (x-mapOffset.x)/width
	local my = (y-mapOffset.y)/width
  -- cartesian to iso pos
	local ix = -(mx/2) + my
	local iy =  (mx/2) + my
	-- round result to get array indexes
	ix = floor(ix)+1
	iy = floor(iy)+1

  -- get tile and replace texture
  if(map.tileData[ix] and map.tileData[ix][iy]) then
		map.tileData[ix][iy].textureKey = "water"
	end

	return {x=ix,y=iy}
end

function map.checkTileCollision(tile,object)
	local width  = (map.data.tileWidth*zoomLevel)
	local height = (map.data.tileHeight*zoomLevel)
	local dx = Math.abs(x - cellCenterX)
	local dy = Math.abs(y - cellCenterY)

	-- this is how genius math is !  :D
	-- this checks if x,y  is within a tile
	if (dx / (cellWidth * 0.5) + dy  (cellHeight * 0.5) <= 1) then

	end
end

return map
