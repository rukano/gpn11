-- LIBS
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
require "sick"

-- FILES
require "menu"
require "game"
require "credits"
require "highscores_screen"
require "classes"

-- lick.clearFlag = true
lick.reset = true
lick.directory = "."

function love.load()
   highscore.set("records", 3, "dummy", 1000)
   highscore.add("dummy", 10)
   highscore.add("foo", 100)
   highscore.save()

   

   width = love.graphics.getWidth()
   height = love.graphics.getHeight()
   screen_center = Vector.new(width/2, height/2)
   
   math.tau = math.pi * 2
   score = 0

   love.graphics.setBackgroundColor(100, 100, 100)
   love.graphics.setBlendMode("alpha")
   love.graphics.setMode(width, height, false, true, 0)
   love.mouse.setVisible(false)

--   Gamestate.switch(game)
   Gamestate.switch(menu)
end


function love.update(dt)
    Gamestate.update(dt)
end

function love.draw()
    Gamestate.draw()
end

function love.keypressed(key, code)
   Gamestate.keypressed(key, code)

   if key == "f12" then
      love.graphics.toggleFullscreen()
   end
end


function love.quit ()
   highscore.save()
   print("Thanks for playing, come back again!")
end
