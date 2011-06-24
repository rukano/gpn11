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

require "menu"
require "game"
require "game_over"
require "highscore"
require "classes"

-- lick.clearFlag = true
lick.reset = true
lick.directory = "."

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

   Gamestate.switch(game)
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
