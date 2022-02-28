local unpack = unpack or table.unpack

local noise = {}
local perlin = {}

function noise.generate( seed,size)
  local perm

  perlin.p = {}

  perlin.size = size
  perlin.gx = {}
  perlin.gy = {}
  perlin.randMax = size
  -- generate permutation matrix pseudo-randomly based on given seed
  local generator = love.math.newRandomGenerator(seed)

  -- generate table with numbers 0 through 255
  local source = {}
  for i=0, size do source[i+1] = i end

  perm = {}
  for i=0, size-1 do
    perm[i + 1] = table.remove(source, generator:random(size - i))
  end
  perlin.permutation =  perm

  for i=1,size do
      perlin.p[i] = perlin.permutation[i]
      perlin.p[size-1+i] = perlin.p[i]
  end

  local grid = {}
  for i=1,size do
    grid[i] = {}
    for j=1,size do
        local x = perlin:noise(i/10, j/10, 0.5)
        grid[i][j] = x
    end
  end

  return grid

end

-- original code by Ken Perlin: http://mrl.nyu.edu/~perlin/noise/
local function BitAND(a,b)--Bitwise and
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra+rb>1 then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    return c
end


function perlin:noise( x, y, z )
    local X = BitAND(math.floor(x), 255) + 1
    local Y = BitAND(math.floor(y), 255) + 1
    local Z = BitAND(math.floor(z), 255) + 1

    -- print("test")
    -- print(X)
    -- print(Y)
    x = x - math.floor(x)
    y = y - math.floor(y)
    z = z - math.floor(z)
    local u = fade(x)
    local v = fade(y)
    local w = fade(z)
    local A  = self.p[X]+Y
    local AA = self.p[A]+Z
    local AB = self.p[A+1]+Z
    local B  = self.p[X+1]+Y
    local BA = self.p[B]+Z
    local BB = self.p[B+1]+Z

    return lerp(w, lerp(v, lerp(u, grad(self.p[AA  ], x  , y  , z  ),
                                   grad(self.p[BA  ], x-1, y  , z  )),
                           lerp(u, grad(self.p[AB  ], x  , y-1, z  ),
                                   grad(self.p[BB  ], x-1, y-1, z  ))),
                   lerp(v, lerp(u, grad(self.p[AA+1], x  , y  , z-1),
                                   grad(self.p[BA+1], x-1, y  , z-1)),
                           lerp(u, grad(self.p[AB+1], x  , y-1, z-1),
                                   grad(self.p[BB+1], x-1, y-1, z-1))))
end

function fade( t )
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function lerp( t, a, b )
    return a + t * (b - a)
end

function grad( hash, x, y, z )
    local h = BitAND(hash, 15)
    local u = h < 8 and x or y
    local v = h < 4 and y or ((h == 12 or h == 14) and x or z)
    return ((h and 1) == 0 and u or -u) + ((h and 2) == 0 and v or -v)
end

return noise
