-- TODO: Optimize through inheritance?
-- TODO: fix crashes when indexing per ID ...

_bombs = {}
_enemies = {}
_powerups = {}

_bomb_count = 0
_enemy_count = 0

max_enemies = 100


--------------------------------------------------------------------------------
-- ENEMIES
Enemy = Class{name="enemy", function(self, player_pos)
			       -- TODO random away from player
			       if #_enemies <= max_enemies then 
				  local x = math.random(width-80) + 40
				  local y = math.random(height-80) + 40
				  local r = 5
				  _enemy_count = _enemy_count + 1
				  self.img = nil
				  self.id = _enemy_count
				  self.color = {255, 100, 100, 255}
				  self.body = love.physics.newBody(world, x, y, 5, 0)
				  self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
				  self.shape:setFriction(0)
				  self.shape:setDensity(0.5)
				  self.shape:setRestitution(0.7)
				  self.shape:setData({type="enemy", instance=self})
				  table.insert(_enemies, self.id, self)
--				  print("spawned enemy", #_enemies)
			       else
				  print("max enemies reached!")
			       end
			    end }
function Enemy:destroy()
   _enemies[self.id].body:destroy()
   _enemies[self.id].shape:destroy()
   table.remove(_enemies, self.id)
end

--------------------------------------------------------------------------------
-- POWERUPS

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
				   table.insert(_powerups, self)
--				   print("spawned powerup", #_powerups)
				end }

--------------------------------------------------------------------------------
-- BOMBS
Bomb = Class{name="bomb", function(self, player_pos)
			     local x, y = unpack(player_pos)
			     local r = 20
			     _bomb_count = _bomb_count + 1
			     self.img = nil
			     self.id = _bomb_count
			     self.color = {100, 255, 100, 255}
			     self.body = love.physics.newBody(world, x, y, 20, 0)
			     self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
			     self.shape:setFriction(1)
			     self.shape:setDensity(2)
			     self.shape:setRestitution(0)
			     self.shape:setData({type="bomb", instance=self})
			     table.insert(_bombs, self.id, self)
--			     print("throwed a bomb")
			  end }

function Bomb:explode()
   print("bomb exploded")
   _bombs[self.id].body:destroy()
   _bombs[self.id].shape:destroy()
   table.remove(_bombs, self.id)
end
