--constatns
local cIdentificationColors = {
  hipJoint = {1, 0, 0.96862745098039, 1}-- "ff00f7"
}
-- dynmic
local textureDir=""

local rigitbody = {
  --size={x=48,y=96},
  body = {
    leg = nil,

  }
}

function getJointPos(texture,idColor)
  -- get rotation pixel by color
  width, height = texture:getDimensions( )
  for x = 1,width-1 do
    for y = 1,height-1 do
     r, g, b, a = texture:getPixel( x, y )
     -- if(r ~= 0) then
     --   print(r .. " ".. g .. " ".. b .. " ".. a )
     --   print(idColor[1] .. " ".. idColor[2] .. " ".. idColor[3].. " ".. idColor[4])
     -- end
     if(0 == r-idColor[1] and g == idColor[2] ) -- and b == idColor[3] and a == idColor[4]
     then
       print("joint found!")
       return {x=x,y=y}
     end
   end
  end
  print("joint color: ")
  print(idColor[1])
  print(idColor[2])
  print(idColor[3])
  print(idColor[4])

end

local leg = {
  texture= nil,
  jointPos = {x=0,y=0},
  rotation = 0
}

local jointPos = nil

function leg:load(src)
  self.texture = love.graphics.newImage("assets/characters/player/leg.png")
  local imageData = love.image.newImageData("assets/characters/player/leg.png")
  idColor = cIdentificationColors.hipJoint
  self.jointPos = getJointPos(imageData,idColor)
  jointPos = self.jointPos
  imageData:release()
  --

  return self
end

local cDegreeToRadian = 0.01745329
local cRadionToDegree = 57.2957795
local degreeCounter = 0
function getDegree()
  degreeCounter = degreeCounter +0.001
  if degreeCounter == 1 then
    degreeCounter = 0
  end
  return degreeCounter
end

function leg:update(dt)


end

function leg:draw()
  self.rotation = getDegree()

  love.graphics.draw(
    self.texture,
    200,200,
    self.rotation,
    1,1,
    jointPos.x,jointPos.y
  )
  --love.graphics.translate(200 + self.jointPos.x, 200 + self.jointPos.y)
  --love.graphics.rotate(self.rotation )
end

function rigitbody:load(dirBodyParts)
  local newBody = rigitbody
  newBody.leg = leg:load(dir)

  return newBody
end

function rigitbody:draw()
  self.leg:draw()
end

function rigitbody:update(dt)
  self.leg:update(dt)
end

return rigitbody
