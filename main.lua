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



-- lick.clearFlag = true
lick.reset = true
lick.directory = "."

--------------------------------------------------------------------------------
-- INIT

function love.load()
   width = love.graphics.getWidth()
   height = love.graphics.getHeight()
   screen_center = Vector.new(width/2, height/2)
   
   math.tau = math.pi * 2
   score = 0

   love.graphics.setBackgroundColor(100, 100, 100)
   love.graphics.setBlendMode("alpha")
   love.graphics.setMode(width, height, false, true, 0)
   love.mouse.setVisible(false)

   -- physics
   world = world or love.physics.newWorld(0, 0, width, height)
   world:setMeter(64)
   world:setCallbacks(bang)
   world:setGravity(0, 0)

   limits = limits or {}
   limits.bodies = limits.bodies or {}
   limits.shapes = limits.shapes or {}

   o = o or {}
   o.bodies = o.bodies or {}
   o.shapes = o.shapes or {}

   half_limiter = 10

   limiters = {}
   limiters.up = {x=0, y=0, w=width, h=20}
   limiters.right = {x=width - 20, y=0, w=20, h=height}
   limiters.down = {x=0, y=height - 20, w=width, h=20}
   limiters.left = {x=0, y=0, w=20, h=height}

   for k,v in pairs(limiters) do
      local r = 20
      limits.bodies[v] = limits.bodies[v] 
         or love.physics.newBody(world, v.x, v.y, 0, 0)
      limits.shapes[v] = limits.shapes[v]
         or love.physics.newRectangleShape(limits.bodies[v], 
                                           v.w/2, v.h/2, v.w, v.h,  0)
      limits.shapes[v]:setFriction(0.8)
      limits.shapes[v]:setDensity(1)
      limits.shapes[v]:setRestitution(0.1)
   end

   -- BG
   bg_img = love.graphics.newImage("img/bg_tile.png")

   -- player
   player = player or {}
   player.image = player.image or  love.graphics.newImage("img/player.png")
   player.body = player.body or love.physics.newBody(world, width/2, height/2, 40, 0)
   player.shape = player.shape or love.physics.newRectangleShape(
      player.body,
      0,
      0,
      player.image:getWidth(),
      player.image:getHeight()
   )
   player.shape:setDensity(100)
   player.shape:setFriction(0.5)
   player.shape:setRestitution(0.1)
   player.pos = player.pos or Vector.new(width/2, height/2)

   -- magnet pointer
   magnet = {}
   magnet.image = love.graphics.newImage("img/magnet.png")
   magnet.pos = Vector.new(love.mouse.getPosition())
   magnet.rot = 0
   magnet.color = {255,255,255,255}
   magnet.power = 1

end

--------------------------------------------------------------------------------
-- UPDATE


function love.update(dt)
   world:update(dt)
   magnet.pos.x, magnet.pos.y = love.mouse.getPosition()

   magnet.rot = getAngle(Vector.new(player.body:getPosition()), magnet.pos)

   -- TODO: make force exponential!
   local line = (magnet.pos 
                  - Vector.new(player.body:getPosition()))
   local force = line * (1/line:len()) * (100 * magnet.power)

   if love.mouse.isDown("l") then
      magnet.color = {0, 255, 0,255}
      player.body:applyForce((force * -1):unpack())
   elseif love.mouse.isDown("r") then
      magnet.color = {255,0,0,255}
      player.body:applyForce((force):unpack())
   else
      magnet.color = {255,255,255,255}
   end
end


--------------------------------------------------------------------------------
-- DRAW
function love.draw()
   drawBG()

   for i,v in pairs(limits.shapes) do
      love.graphics.setColor(0, 0, 0)
      love.graphics.polygon("fill", v:getPoints())
   end

   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(player.image, 
                      player.body:getX(), 
                      player.body:getY(), 0, 1, 1, 
                      player.image:getWidth()/2, player.image:getHeight()/2)

   love.graphics.setColor(unpack(magnet.color))
   love.graphics.draw(magnet.image, 
                      magnet.pos.x, 
                      magnet.pos.y, 
                      magnet.rot + (math.pi/2), 1, 1, 
                      magnet.image:getWidth(), magnet.image:getHeight()/2)

   drawMagnetism()
   drawScore()
end


function love.keypressed (key)
   if key == "up" then
      magnet.power = magnet.power + 1
   elseif key == "down" then 
      magnet.power = magnet.power - 1      
   end
end


--------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------


function getAngle (a,b)
   local c = Vector.new(math.abs(a.x - b.x), 
                        math.abs(a.y - b.y))
   local rad = (math.atan2(c:unpack()))

   if (b.x - a.x) < 0 then
      rad = math.tau - rad 
   end
   if (b.y - a.y) > 0 then
      rad =  math.tau - ((rad) + (math.pi))
    end

   return rad
 end


function drawMagnetism ()
   love.graphics.setColor(100, 200, 255, 255)
   love.graphics.setLineWidth(1)
   love.graphics.print("Magnet Power: " .. tostring(magnet.power * 10) .. "%", 20, 3)
   love.graphics.rectangle("fill", 160, 3, magnet.power * 10, 13)
   love.graphics.setColor(255, 100, 255, 255)
   love.graphics.rectangle("line", 160, 3, 100, 13)
end


function drawScore ()
   love.graphics.setColor(100, 200, 255, 255)
   love.graphics.print("Score: " .. tostring(score), width-200, 3)
end


function drawBG ()
   local tile = 32
   local num = {cols=width/tile, rows=height/tile}
   love.graphics.setColor(100, 100, 100, 10)
   for i=0, num.rows do
      for j=0, num.cols do
	 love.graphics.draw(bg_img, j * tile, i * tile, 0, 1, 1)
      end
   end
end