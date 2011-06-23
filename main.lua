require "LICK"
require "LICK/lib"
ez = require "LICK/lib/hlpr"

--lick.clearFlag = true
lick.reset = true

----------------------------------------

function love.load()
   --initial graphics setup
   love.graphics.setBackgroundColor(100, 100, 200)
   love.graphics.setBlendMode("alpha")
   
   love.graphics.setMode(width, height, false, true, 0)
   
   
   width = 650
   height = 650
   
   world = world or love.physics.newWorld(-width, -height, width, height)
   world:setMeter(64)
   world:setCallbacks(bang)

   world:setGravity(0, 2000)

   forceX = 10000
   forceY = 10000
   
   bodies = bodies or {}
   shapes = shapes or {}
   limits = limits or {}
   gravity = gravity or {}

   o = o or {}

   o.bodies = o.bodies or {}
   o.shapes = o.shapes or {}

   gravity.x = 0
   gravity.y = 500
end


function love.update(dt)
   world:update(dt)
end

function love.draw()

end

function bang (a, b, coll)

end
