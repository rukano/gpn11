highscores_screen = Gamestate.new()
gameover = Gamestate.new()

--------------------------------------------------------------------------------
-- GAME OVER

function gameover:update(dt)
   timeout = timeout - dt
   if timeout < 0 then
      Gamestate.switch(highscores_screen)
   end
end

function gameover:enter()
   love.audio.play("music/gameover.ogg", "stream")
   love.graphics.setBackgroundColor(0, 0, 0)
   timeout = 5
   Timer.add(timeout, function() Gamestate.switch(highscores_screen) end)
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

--------------------------------------------------------------------------------
-- HIGH SCORES
function highscores_screen:enter (prev)
   love.graphics.setFont(font)
   hs_music = love.audio.play("music/highscore.ogg", "stream", true)
end

function highscores_screen:leave ()
   love.audio.stop(hs_music)
end

function highscores_screen:update (dt)
   updateStars(dt)
end

function highscores_screen:draw ()
   love.graphics.setBackgroundColor(0, 0, 0, 255)

   drawStars()

   love.graphics.setColor(100, 100, 255, 255)
   
   for i,v in pairs(scores_table) do
      love.graphics.print(v.name, 100, (50 * (i-1)) + 20)
      love.graphics.print(". . . . . .", 200, (50 * (i-1)) + 20)
      love.graphics.print(v.score, 350, (50 * (i-1)) + 20)
   end
end

function highscores_screen:keypressed (key, code)
   if key == "escape" then
      Gamestate.switch(menu)
   end
end