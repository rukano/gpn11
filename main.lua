require "LICK"
require "LICK/lib"
AnAL = require "AnAL/AnAL"
ez = require "LICK.lib.hlpr"
Timer = require "LICK.lib.hump.timer"
Gamestate = require "LICK.lib.hump.gamestate"
Vector = require "LICK.lib.hump.vector"
Class = require "LICK.lib.hump.class"
Camera = require "LICK.lib.hump.camera"
HC = require "HardonCollider"



--lick.clearFlag = true
lick.reset = true
lick.directory = "."

--------------------------------------------------------------------------------
-- INIT

function love.load()
   width = love.graphics.getWidth()
   height = love.graphics.getHeight()
   screen_center = Vector.new(width/2, height/2)
   
   -- initial graphics setup
   love.graphics.setBackgroundColor(100, 100, 200)
   love.graphics.setBlendMode("alpha")
   love.graphics.setMode(width, height, false, true, 0)

   -- player
   player = {}
   player.image = love.graphics.newImage("img/player.png")
   player.pos = Vector.new(width/2, height/2)
   player.dpos = Vector.new(0, 0)
   player.rotation = 0
   player.drot = 0
   player.rot = 0

   player.update = function(dt)
                      --player.drot = player.drot - (player.drot * 0.9 * dt)
                      player.dpos.x = player.dpos.x  + (math.random(-5, 5) * dt)
                      player.dpos.y = player.dpos.y  + (math.random(-5, 5) * dt)

                      player.rot = player.rot + player.drot
                      player.pos = player.pos + player.dpos
--                      print(player.dpos.x)

                   end
   player.push = function(dt, direction)
                    --print("pushing")
                    player.drot = player.drot + (dt * 0.1 * direction)
                 end

   -- magnet pointer
   magnet = {}
   magnet.image = love.graphics.newImage("img/magnet.png")
   magnet.pos = Vector.new(love.mouse.getPosition())
   magnet.rot = 0
   magnet.force = 1
   magnet.color = {255,255,255,255}
end

--------------------------------------------------------------------------------
-- UPDATE

function love.update(dt)
   magnet.pos.x, magnet.pos.y = love.mouse.getPosition()
   magnet.rot = math.atan2( (magnet.pos - screen_center):unpack() )

   if love.mouse.isDown("l") then
      magnet.color = {0,0,255,255}
   elseif love.mouse.isDown("r") then
      magnet.color = {255,0,0,255}
   else
      magnet.color = {255,255,255,255}
   end

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
   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(player.image, player.pos.x, player.pos.y, player.rot, 1, 1, player.image:getWidth()/2, player.image:getHeight()/2)
   love.graphics.setColor(unpack(magnet.color))
   love.graphics.draw(magnet.image, magnet.pos.x, magnet.pos.y, magnet.rot, 1, 1, magnet.image:getWidth(), magnet.image:getHeight()/2)
end


--------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------

