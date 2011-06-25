game = Gamestate.new()

frames = 0

function game:init()
end

--------------------------------------------------------------------------------
-- UPDATE


function game:update(dt)
   world:update(dt)

   magnet.pos.x, magnet.pos.y = love.mouse.getPosition()
   magnet.rot = getAngle(Vector.new(player.body:getPosition()), magnet.pos)

   Timer.update(dt)

   local line = (magnet.pos 
                  - Vector.new(player.body:getPosition()))
   local force = line * (1/line:len()) * (100 * magnet.power)

   for _,i in pairs({_powerups, _enemies, _bombs}) do
      for index,v in pairs(i) do
         if v.alive then
            v:update(dt)
         else
            v.shape = nil
            v.body = nil
            table.remove(i, index)  
         end
      end
   end
      
   if love.mouse.isDown("l") then
      magnet.color = {0, 255, 0,255}
      player.body:applyForce((force * -1):unpack())
   elseif love.mouse.isDown("r") then
      magnet.color = {255,0,0,255}
      player.body:applyForce((force):unpack())
   else
      magnet.color = {255,255,255,255}
   end

   frames = frames + 1

   if frames % 100 == 0 then
      Enemy()
   end
   if frames % 200 == 0 then
      Powerup()
   end
end


--------------------------------------------------------------------------------
-- DRAW
function game:draw()
   drawBG()

   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(player.image, 
                      player.body:getX(), 
                      player.body:getY(), 0, 1, 1, 
                      player.image:getWidth()/2, player.image:getHeight()/2)

   drawObjects()
   drawMagnetMouse()
   drawHeader()
   drawScore()
end


function game:enter(previous)
   frames = 0
   love.graphics.setFont(10)
   

   -- physics
   world = world or love.physics.newWorld(0, 0, width, height)
   world:setMeter(64)
   world:setCallbacks(bang)
   world:setGravity(0, 0)
   world:setCallbacks(on_collision)

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
      limits.shapes[v]:setData{type="border"}
   end

   -- BG
   bg_img = love.graphics.newImage("img/bg.png")

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
   player.shape:setData{type="player"}
   player.pos = player.pos or Vector.new(width/2, height/2)
   player.life = 10
   player.looselife = function() player.life = math.max(player.life - 1, 1) end

   -- magnet pointer
   magnet = {}
   magnet.image = love.graphics.newImage("img/magnet.png")
   magnet.pos = Vector.new(love.mouse.getPosition())
   magnet.rot = 0
   magnet.color = {255,255,255,255}
   magnet.power = 1
   magnet.powerup = function() magnet.power = math.min(magnet.power + 1, 10) end


end

function game:leave()
   print("----------------------------------")
   print("leaving the game... goto highscore")
   print("PLS Remove bodies, etc!!!")
   print("----------------------------------")
   
end

function game:keypressed (key)
   if key == "up" then
      magnet.power = magnet.power + 1
   elseif key == "down" then 
      magnet.power = magnet.power - 1      
   end

   if key == " " then
      Bomb({player.body:getPosition()})
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


function drawHeader ()
   love.graphics.setColor(100, 200, 255, 255)
   love.graphics.setLineWidth(1)
   love.graphics.print("Magnet Power: " .. tostring(magnet.power * 10) .. "%", 20, 3)
   love.graphics.rectangle("fill", 160, 3, magnet.power * 10, 13)
   love.graphics.setColor(255, 100, 255, 255)
   love.graphics.rectangle("line", 160, 3, 100, 13)

   local offset = 300
   love.graphics.setColor(255, 200, 55, 255)
   love.graphics.setLineWidth(1)
   love.graphics.print("Life: " .. tostring(player.life * 10) .. "%", 20 + offset, 3)
   love.graphics.rectangle("fill", 160 + offset, 3, player.life * 10, 13)
   love.graphics.setColor(255, 100, 255, 255)
   love.graphics.rectangle("line", 160 + offset, 3, 100, 13)
end


function drawScore ()
   love.graphics.setColor(100, 200, 255, 255)
   love.graphics.print("Score: " .. tostring(score), width-200, 3)
end


-- function drawBG ()
--    local tile = 32
--    local num = {cols=width/tile, rows=height/tile}
--    love.graphics.setColor(100, 100, 100, 255)
--    for i=0, num.rows do
--       for j=0, num.cols do
-- 	 love.graphics.draw(bg_img, j * tile, i * tile, 0, 1, 1)
--       end
--    end
-- end


function drawBG ()
   love.graphics.setColor(0, 55, 55, 255)
   love.graphics.draw(bg_img, 0, 0)

   for k,v in pairs(limits.shapes) do
      love.graphics.setColor(0, 0, 25, 255)
      love.graphics.polygon("fill", v:getPoints())
   end

end

function drawMagnetMouse ()
   love.graphics.setColor(unpack(magnet.color))
   love.graphics.draw(magnet.image, 
                      magnet.pos.x, 
                      magnet.pos.y, 
                      magnet.rot + (math.pi/2), 1, 1, 
                      magnet.image:getWidth(), magnet.image:getHeight()/2)
end

function drawObjects ()
   -- POWERUPS
   for _,i in pairs({_powerups, _enemies, _bombs}) do
      for k,v in pairs(i) do
         v:draw()
      end
   end
end

function on_collision (a, b, coll)
   local player_inst = false
   local other
   if a.type == "player" then
      player_shape = a
      other = b
   end
   if b.type == "player" then
      player_shape = b
      other = a
   end
   if player_shape then
      if other then
         if other.type == "powerup" then
            magnet.powerup()
            other.instance:destroy()
         elseif other.type == "enemy" then
            player.looselife()
            other.instance:bounceOff(player_shape, coll)
         end
      end
   end
      --   print(a.type, b.type, coll)
end