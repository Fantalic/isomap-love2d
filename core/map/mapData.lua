
local data = {
  tiles = {}
}


function data:load(data)
  for colunas in ipairs(map.data.ground) do
		self.tiles[colunas] = {}
		for linhas in ipairs(data.ground[colunas]) do
				local xPos = linhas
				local yPos = colunas
				local tKey = data.ground[colunas][linhas]
				self.tiles[colunas][linhas] = { {
          textureKey = tKey,
          x=xPos, y=yPos,
          offSetX = 0,
          offSetY = 0,
          height  = 0
        } }
		end
	end
end

function data:getLayer(level)
  --return control object
end

function data:getObject(linhas,colunas)
  --TODO: move one layer up/down
end

return data
