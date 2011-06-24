-- TODO: Optimize through inheritance?

--------------------------------------------------------------------------------
-- ENEMIES

_enemies = {}
max_enemies = 100
Enemy = Class{name="enemy", function(self, player_pos)
			       -- TODO random away from player
			       if #_enemies <= max_enemies then 
				  local x = math.random(width-80) + 40
				  local y = math.random(height-80) + 40
				  local r = 5
				  self.img = nil
				  self.color = {255, 100, 100, 255}
				  self.body = love.physics.newBody(world, x, y, 5, 0)
				  self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
				  self.shape:setFriction(0)
				  self.shape:setDensity(0.5)
				  self.shape:setRestitution(0.7)
				  self.shape:setData({type="enemy", instance=self})
				  table.insert(_enemies, self)
--				  print("spawned enemy", #_enemies)
			       else
				  print("max enemies reached!")
			       end
			    end }

--------------------------------------------------------------------------------
-- POWERUPS

_powerups = {}
Powerup = Class{name="powerup", function(self, player_pos)
				   local x = math.random(width-80) + 40
				   local y = math.random(height-80) + 40
				   local r = 10
				   self.img = nil
				   self.color = {100, 100, 255, 255}
				   self.body = love.physics.newBody(world, x, y, 20, 0)
				   self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
				   self.shape:setFriction(1)
				   self.shape:setDensity(2)
				   self.shape:setRestitution(0)
				   self.shape:setData({type="powerup", instance=self})
				   table.insert(_enemies, self)
--				   print("spawned powerup", #_powerups)
				end }

--------------------------------------------------------------------------------
-- BOMBS

_bombs = {}
Bomb = Class{name="bomb", function(self, player_pos)
			     local x = player_pos.x
			     local y = player_pos.y
			     local r = 20
			     self.img = nil
			     self.color = {100, 255, 100, 255}
			     self.body = love.physics.newBody(world, x, y, 20, 0)
			     self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
			     self.shape:setFriction(1)
			     self.shape:setDensity(2)
			     self.shape:setRestitution(0)
			     self.shape:setData({type="bomb", instance=self})
			     table.insert(_bombs, self)
--			     print("throwed a bomb")
			  end }

function Bomb:destroy()
   print("bomb destroyed", #_bombs)
   print(self)
   self = nil -- or remove from table?
   print(#_bombs)
end
