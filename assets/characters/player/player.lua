
local player = {
  sheet=nil,
  anim=nil,
  speed=0.2,
  width=0,
  heigth=0,
  orientation={true,true,true,true}

}

function player.load()
  player.sheet = love.graphics.newImage("assets/characters/player/sheet.png")
  player.width = player.sheet:getWidth()
  player.height = player.sheet:getHeight()
  player.speed = 0.2
  player.grid = anim8.newGrid(16*pixelSize-4,24*pixelSize,w,h)--
  player.animations = {}
  player.animations.down = anim8.newAnimation(player.grid('1-3',1), speed)
  player.animations.up = anim8.newAnimation(player.grid('1-3',3), speed)
  player.animations.left = anim8.newAnimation(player.grid('1-3',2), speed)
  player.animations.right = anim8.newAnimation(player.grid('1-3',2),speed)
  player.anim = player.animations.down
end
