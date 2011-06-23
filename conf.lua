function love.conf(t)
   t.modules.joystick = true
   t.modules.audio = true
   t.modules.keyboard = true
   t.modules.event = true
   t.modules.image = true
   t.modules.graphics = true
   t.modules.timer = true
   t.modules.mouse = true
   t.modules.sound = true
   t.modules.physics = true
   t.console = false
   t.title = "GPN11"
   t.author = "rukano, hb, bios"
   t.screen.fullscreen = false
   t.screen.vsync = true
   t.screen.fsaa = 0           -- The number of FSAA-buffers (number)
   t.screen.height = 600       -- The window height (number)
   t.screen.width = 800        -- The window width (number)

   t.version = 0.7             -- The LÖVE version this game was made for (number)
end
