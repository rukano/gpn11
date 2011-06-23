require "LICK"
require "LICK/lib"
ez = require "LICK.lib.hlpr"
Timer = require "LICK.lib.hump.timer"
Gamestate = require "LICK.lib.hump.gamestate"
Vector = require "LICK.lib.hump.vector"
Class = require "LICK.lib.hump.class"
Camera = require "LICK.lib.hump.camera"

--lick.clearFlag = true
lick.reset = true

--------------------------------------------------------------------------------
-- INIT

function love.load()
   width = 650
   height = 650

   -- initial graphics setup
   love.graphics.setBackgroundColor(100, 100, 200)
   love.graphics.setBlendMode("alpha")
   love.graphics.setMode(width, height, false, true, 0)

   -- physics world
   world = world or love.physics.newWorld(-width, -height, width, height)
   world:setMeter(64)
   world:setCallbacks(bang)
   world:setGravity(0, 2000)

   -- global tables
   bodies = bodies or {}
   shapes = shapes or {}
   limits = limits or {}
   gravity = gravity or {}

   -- objects: bodies and shapes
   o = o or {}
   o.bodies = o.bodies or {}
   o.shapes = o.shapes or {}
end

--------------------------------------------------------------------------------
-- UPDATE

function love.update(dt)
   world:update(dt)
end

--------------------------------------------------------------------------------
-- DRAW
function love.draw()

end

--------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------

-- collision detection
function bang (a, b, coll)

end
