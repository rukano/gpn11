--[[
Player = Class{name="Player", function(self)
				 self.pos = Vector(width/2, height/2)
				 self.body
				 self.shape
			      end }
--]]

_enemies = {}
max_enemies = 100

Enemy = Class{name="Enemy", function(self, player_pos)
			       -- TODO random away from player
			       if #_enemies <= max_enemies then 
				  local x = math.random(width-80) + 40
				  local y = math.random(height-80) + 40
				  local r = 10
				  self.img = nil
				  self.body = love.physics.newBody(world, x, y, 5, 0)
				  self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
				  self.shape:setFriction(0)
				  self.shape:setDensity(0.5)
				  self.shape:setRestitution(0.7)
				  self.shape:setData({type="enemy"})
				  table.insert(_enemies, self)
				  print("spawned enemy", #_enemies)
			       else
				  print("max enemies reached!")
			       end
			    end }



