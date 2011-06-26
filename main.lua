-- LIBS
Timer = require "hump.timer"
Gamestate = require "hump.gamestate"
Vector = require "hump.vector"
Class = require "hump.class"
ez = require "hlpr"

-- FILES
require "menu"
require "game"
require "credits"
require "highscores_screen"
require "classes"

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

   scores_file = love.filesystem.newFile( "records.txt" )
   scores_file:open('r')
   scores_counter = 0
   scores_table = {}
   for line in scores_file:lines() do
      scores_counter = scores_counter + 1
      local t = {}
      local score, name
      score, name = string.match(line, "(%d+) (%w+)")
      t.score = score
      t.name = name
      table.insert(scores_table, scores_counter, t)
   end
   scores_file:close()

   images = {}
   images.enemy = love.graphics.newImage("img/enemy.png")
   images.powerup = love.graphics.newImage("img/power_up.png")
   images.bomb = love.graphics.newImage("img/bomb.png")
   images.boom = love.graphics.newImage("img/boom.png")

   font = love.graphics.newFont( "game_over.ttf" , 128)
   love.graphics.setFont(font)

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
--   saveHighscores()
   print("Thanks for playing, come back again!")
end


function saveHighscores ()
   local afile = love.filesystem.newFile( "meh.txt")
   local str = ""
--   print(file)
   afile:open("w")
   for i,v in pairs(scores_table) do
      str = str .. tostring(v.score) .. " " .. v.name .. "\n"
   end
   print("wrtie highscores")
   afile:write("blabla")
   afile:close()
end

