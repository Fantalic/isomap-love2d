function insertObject(mx,my)
  -- body...
	clickedTile = isomap.getTileByPos(x,y)
  --isomap.insertNewObject(clickedTile.x,clickedTile.y,"tree",0)
	isomap:insertNewObject(clickedTile.x,clickedTile.y,"tree",0)
end
