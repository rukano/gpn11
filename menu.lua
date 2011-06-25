menu = Gamestate.new()

function menu:init ()

end

function menu:enter(previous)
   love.graphics.setBackgroundColor(0, 0, 0, 255)
   love.graphics.setFont(48)

   items = items or {"[F1] start","[F2] highscores","[F3] credits", "[F4] quit"}

   star_img = star_img or love.graphics.newImage("LICK/lib/images/star.png")
   magnet_img = magnet_img or love.graphics.newImage("img/magnet.png")
   player_img = player_img or love.graphics.newImage("img/player.png")
   player_y = 100

   stars = stars or {}
   for i=1, 50 do
      local s = {}
      local rand = 100 + math.random(155)
      local lumi = math.random(100, 255)

      s.size = (math.random(200) / 4000) + 0.075
      s.pos = Vector.new(math.random(width), math.random(height))
      s.speed = (math.random(1000)/100) + 1
      s.color = {rand, rand, rand, lumi}
      s.rot = (math.random(100)/100) * math.pi * 2
      s.drot = ez.choose{1, -1}
      table.insert(stars, s)
   end

   frames = 0
end

function menu:leave()

end

function menu:update(dt)
   updateStars(dt)
   updateOthers(dt)
   frames = frames + 1
end

function menu:draw()
   drawStars()
   drawTitle()
   drawItems()
   drawOthers()
end

function menu:keypressed(key)
   if key == "f1" then
      Gamestate.switch(game)
   elseif key == "f2" then
      Gamestate.switch(highscores_screen)
   elseif key == "f3" then
      Gamestate.switch(credits)
   elseif key == "f4" then
      love.quit()
   end
end

function menu:mousepressed(x, y, btn)

end

--------------------------------------------------------------------------------
-- My funcs

function updateStars (dt)
   for k,v in pairs(stars) do
      v.pos.y = v.pos.y + (v.speed * dt)
      v.pos.y = v.pos.y % (height+20)
      v.rot = v.rot + (v.drot * dt * (v.speed/10))
   end
end

function updateOthers (dt)
   player_y = wrap(frames*2, 100, 400)
end


function drawStars ()
   local off = 64
   for k,v in pairs(stars) do
      love.graphics.setColor(unpack(v.color))
      love.graphics.draw(star_img, v.pos.x, v.pos.y, v.rot, v.size, v.size, off, off)
   end
end

function drawTitle ()
   love.graphics.setColor(100, 100, 255, 255)
   love.graphics.print("Mag.Net", 100, 100, 0, 1, 1)
end

function drawItems ()
   for i,v in ipairs(items) do
      love.graphics.setColor(100, 200, 255, 255)
      love.graphics.print(v, 150, 300 + ((i-1) * 40), 0, 0.5, 0.5)
   end
end

function drawOthers()
   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.draw(player_img, 700, player_y)
   love.graphics.draw(magnet_img, 683, 500, math.pi*3/2)
end

--------------------------------------------------------------------------------
-- THis schould go to a library...

function even (num)
   if math.floor(num % 2) == 0 then
      return true
   else
      return false
   end
end

function odd (num)
   if math.floor(num % 2) == 1 then
      return true
   else
      return false
   end
end


function wrap (num, min, max)
   if (not min) and (not max) then
      max = 1
      min = 0
   elseif not max then
      max = min
      min = 0
   end
   
   local range = max-min
   local norm = num-min
   
   if even(num / range) then
      return (num % (range*2)) + min
   else
      return (range - (num % range)) + min
   end
end