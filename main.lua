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
-- require "sick"

-- FILES
require "menu"
require "game"
require "credits"
require "highscores_screen"
require "classes"

-- lick.clearFlag = true
lick.reset = true
lick.directory = "."

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- SOUND MANAGER
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
do
    -- will hold the currently playing sources
    local sources = {}

    -- check for sources that finished playing and remove them
    -- add to love.update
    function love.audio.update()
        local remove = {}
        for _,s in pairs(sources) do
            if s:isStopped() then
                remove[#remove + 1] = s
            end
        end

        for i,s in ipairs(remove) do
            sources[s] = nil
        end
    end

    -- overwrite love.audio.play to create and register source if needed
    local play = love.audio.play
    function love.audio.play(what, how, loop)
        local src = what
        if type(what) ~= "userdata" or not what:typeOf("Source") then
            src = love.audio.newSource(what, how)
            src:setLooping(loop or false)
        end

        play(src)
        sources[src] = src
        return src
    end

    -- stops a source
    local stop = love.audio.stop
    function love.audio.stop(src)
        if not src then return end
        stop(src)
        sources[src] = nil
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- CODE
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function love.load()
--   highscore.set("records.lua", 3, "dummy", 1000)
--   highscore.add("rukano", 10000)
--   highscore.save()

   width = love.graphics.getWidth()
   height = love.graphics.getHeight()
   screen_center = Vector.new(width/2, height/2)
   
   math.tau = math.pi * 2
   score = 0

   images = {}
   images.enemy = love.graphics.newImage("img/enemy.png")
   images.powerup = love.graphics.newImage("img/power_up.png")
   images.bomb = love.graphics.newImage("img/bomb.png")
   images.boom = love.graphics.newImage("img/boom.png")

   love.graphics.setBackgroundColor(100, 100, 100)
   love.graphics.setBlendMode("alpha")
   love.graphics.setMode(width, height, false, true, 0)
   love.mouse.setVisible(false)

--   Gamestate.registerEvents()
   Gamestate.switch(menu)
end

function love.update(dt)
   Gamestate.update(dt)
   love.audio.update()
end

function love.draw()
   Gamestate.draw()
end

function love.keypressed(key, code)
   if key == "f12" then
      love.graphics.toggleFullscreen()
   end
   Gamestate.keypressed(key, code)
end

function love.mousepressed (x, y, btn)
   Gamestate.mousepressed(x, y, btn)
end

function love.mousereleased (x, y, btn)
   Gamestate.mousereleased(x, y, btn)
end


function love.quit ()
--   highscore.save()
   print("Thanks for playing, come back again!")
end
