-- TODO: Optimize through inheritance?
-- TODO: fix crashes when indexing per ID ...

_bombs = {}
_enemies = {}
_powerups = {}

_bomb_count = 0
_enemy_count = 0

max_enemies = 100


Entity = Class(function(self) 
                  self.alive = true
               end)


function Entity:draw()
   if self.alive then
      love.graphics.draw(self.img, 
                         self.body:getX(),
                         self.body:getY(),
                         self.body:getAngle(),
                         self.scale,
                         self.scale
                      )
   end
end

function Entity:update(dt)
end

--------------------------------------------------------------------------------
-- ENEMIES
Enemy = Class{name="enemy", function(self, player_pos)
			       -- TODO random away from player
                               Entity.construct(self)
			       if #_enemies <= max_enemies then 
				  local x = math.random(width-80) + 40
				  local y = math.random(height-80) + 40
				  local r = 5
				  _enemy_count = _enemy_count + 1
				  self.img = images.enemy
				  self.id = _enemy_count

				  self.color = {255, 100, 100, 255}
				  self.body = love.physics.newBody(world, x, y, 5, 0.5)
				  self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
				  self.shape:setFriction(0)
				  self.shape:setDensity(0.5)
				  self.shape:setRestitution(0.7)
				  self.shape:setData({type="enemy", instance=self})
                                  self.scale = r/self.img:getWidth()
                                  self.body:applyTorque(math.random(-100,100))
				  table.insert(_enemies, self.id, self)
                                  --				  print("spawned enemy", #_enemies)
			       else
				  print("max enemies reached!")
			       end
			    end }

Enemy:inherit(Entity)

function Enemy:destroy()
   self.alive = false
   self.body:setX(math.random(-5000, -10))
   self.body:setY(math.random(-5000, -10))
   self.shape:setMask(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
end



--------------------------------------------------------------------------------
-- POWERUPS

Powerup = Class{name="powerup", function(self, player_pos)
                                   Entity.construct(self)
				   local x = math.random(width-80) + 40
				   local y = math.random(height-80) + 40
				   local r = 10
				   self.img = images.powerup

				   self.color = {100, 100, 255, 255}
				   self.body = love.physics.newBody(world, x, y, 20, 0.4)
				   self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
				   self.shape:setFriction(1)
				   self.shape:setDensity(2)
				   self.shape:setRestitution(0)
				   self.shape:setData({type="powerup", instance=self})
                                   self.body:applyTorque(math.random(-100,100))
                                   self.scale = r/self.img:getWidth()
				   table.insert(_powerups, self)
                                   Timer.add(20, function() 
                                                    self.alive = false
                                                 end)
                                   --				   print("spawned powerup", #_powerups)
				end }

Powerup:inherit(Entity)



--------------------------------------------------------------------------------
-- BOMBS
Bomb = Class{name="bomb", function(self, player_pos)
                             Entity.construct(self)
			     local x, y = unpack(player_pos)
			     local r = 20
			     _bomb_count = _bomb_count + 1
			     self.img = images.bomb
			     self.id = _bomb_count
			     self.color = {100, 255, 100, 255}
			     self.body = love.physics.newBody(world, x, y, 20, 1)
			     self.shape = love.physics.newCircleShape(self.body, 0, 0, r)
			     self.shape:setFriction(1)
			     self.shape:setDensity(2)
			     self.shape:setRestitution(0)
			     self.shape:setData({type="bomb", instance=self})
                             self.body:applyTorque(math.random(-100,100))
                             self.scale = r/self.img:getWidth()
			     table.insert(_bombs, self.id, self)
                             --			     print("throwed a bomb")
			  end }
Bomb:inherit(Entity)

function Bomb:explode()
   print("bomb exploded")
   self.alive = false
end
