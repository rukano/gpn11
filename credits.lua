credits = Gamestate.new()

function credits:enter (prev)
   love.graphics.setFont(font)
   credits_music = love.audio.play("music/menu.ogg", "stream", true)
end

function credits:leave ()
   love.audio.stop(credits_music)
end

function credits:update (dt)
   updateStars(dt)
end

function credits:draw ()
   love.graphics.setBackgroundColor(0, 0, 0, 255)

   drawStars()

   love.graphics.setColor(200, 200, 255, 255)
   love.graphics.print("rukano", 100, 100)
   love.graphics.print("hb", 100, 200)
end

function credits:keypressed (key, code)
   if key == "escape" then
      Gamestate.switch(menu)
   end
end