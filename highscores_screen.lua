highscores_screen = Gamestate.new()



gameover = Gamestate.new()


function gameover:update(dt)
   timeout = timeout - dt
   if timeout < 0 then
      Gamestate.switch(highscores_screen)
   end
end

function gameover:enter()
   love.graphics.setBackgroundColor(0, 0, 0)
   timeout = 5
end

function gameover:draw()
   love.graphics.setColor(255, 255, 255, 125) 
   local scale = timeout/5
   local rand = 10
   for i = 1, 20 do
      love.graphics.print("game over", 
                          (width/3) + (math.random(-rand,rand) * scale),
                          height * 5/8 + (math.random(-rand,rand) * scale),
                          0,
                          4,
                          4)
   end
end