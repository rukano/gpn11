require "LICK"
require "LICK/lib"
AnAL = require "AnAL/AnAL"
ez = require "LICK.lib.hlpr"
Timer = require "LICK.lib.hump.timer"
Gamestate = require "LICK.lib.hump.gamestate"
Vector = require "LICK.lib.hump.vector"
Class = require "LICK.lib.hump.class"
Camera = require "LICK.lib.hump.camera"



--lick.clearFlag = true
lick.reset = true
lick.directory = "."

--------------------------------------------------------------------------------
-- INIT

function love.load()
   width = 650
   height = 650

   -- initial graphics setup
   love.graphics.setBackgroundColor(100, 100, 200)
   love.graphics.setBlendMode("alpha")
   love.graphics.setMode(width, height, false, true, 0)

   player = {}
   player.image = love.graphics.newImage("img/player.png")
   player.pos = Vector.new(50, 50)
   player.dpos = Vector.new(0, 0)
   player.rotation = 0
   player.drot = 0
   player.update = function(dt)
                      player.drot = player.drot - (1 * dt)
                      player.dpos = player.dpos - (1 * dt)
                   end
   player.push = function(dt, direction)
                    player.drot = math.max(player.drot + (dt * 1 * direction), 0.1)
                 end
   

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
   if love.keyboard.isDown("left") then
      player.push(dt, -1)
      -- drehen links
   elseif love.keyboard.isDown("right") then
      -- drehen rechts
      player.push(dt, 1)
   elseif love.keyboard.isDown("up") then
      -- entmagnetisieren
      player.magnetic = false
   elseif love.keyboard.isDown("down") then
      -- magnetisieren
      player.magnetic = true
   end

   player.update(dt)
end

--------------------------------------------------------------------------------
-- DRAW
function love.draw()
   love.graphics.draw(player.image, player.pos:unpack(), player.rot)
end


--------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------

-- collision detection
function bang (a, b, coll)

end
