--[[
Copyright (c) 2011 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

module(..., package.seeall)
local Shapes      = require(_NAME .. '.shapes')
local Polygon     = require(_NAME .. '.polygon')
local Spatialhash = require(_NAME .. '.spatialhash')
local vector      = require(_NAME .. '.vector')

local PolygonShape = Shapes.PolygonShape
local CircleShape  = Shapes.CircleShape
local PointShape   = Shapes.PointShape

local is_initialized = false
local hash = nil

local active_shapes, passive_shapes, ghosts = {}, {}, {}
local current_shape_id = 0
local shape_ids = setmetatable({}, {__mode = "k"})
local groups = {}

local function __NOT_INIT() error("Not yet initialized") end
local function __NULL() end
local cb_collide, cb_stop = __NOT_INIT, __NOT_INIT

function init(cell_size, callback_collide, callback_stop)
	cb_collide = callback_collide or __NULL
	cb_stop    = callback_stop    or __NULL
	hash = Spatialhash(cell_size)
	is_initialized = true
end

function setCallbacks(collide, stop)
	if type(collide) == "table" and not (getmetatable(collide) or {}).__call then
		stop = collide.stop
		collide = collide.collide
	end

	if collide then
		assert(type(collide) == "function" or (getmetatable(collide) or {}).__call,
			"collision callback must be a function or callable table")
		cb_collide = collide
	end

	if stop then
		assert(type(stop) == "function" or (getmetatable(stop) or {}).__call,
			"stop callback must be a function or callable table")
		cb_stop = stop
	end
end

local function new_shape(shape, ul,lr)
	current_shape_id = current_shape_id + 1
	active_shapes[current_shape_id] = shape
	shape_ids[shape] = current_shape_id
	hash:insert(shape, ul,lr)
	shape._groups = {}
	return shape
end

-- create polygon shape and add it to internal structures
function addPolygon(...)
	assert(is_initialized, "Not properly initialized!")
	local shape = PolygonShape(...)

	-- replace shape member function with a function that updates
	-- the hash
	local function hash_aware_member(oldfunc)
		return function(self, ...)
			local x1,y1, x2,y2 = self._polygon:getBBox()
			oldfunc(self, ...)
			local x3,y3, x4,y4 = self._polygon:getBBox()
			hash:update(self, vector(x1,y1), vector(x2,y2), vector(x3,y3), vector(x4,y4))
		end
	end
	shape.move = hash_aware_member(shape.move)
	shape.moveTo = hash_aware_member(shape.moveTo)
	shape.rotate = hash_aware_member(shape.rotate)

	function shape:_getNeighbors()
		local x1,y1, x2,y2 = self._polygon:getBBox()
		return hash:getNeighbors(self, vector(x1,y1), vector(x2,y2))
	end
	function shape:_removeFromHash()
		local x1,y1, x2,y2 = self._polygon:getBBox()
		hash:remove(shape)--, vector(x1,y1), vector(x2,y2))
	end

	local x1,y1, x2,y2 = shape._polygon:getBBox()
	return new_shape(shape, vector(x1,y1), vector(x2,y2))
end

function addRectangle(x,y,w,h)
	return addPolygon(x,y, x+w,y, x+w,y+h, x,y+h)
end

-- create new polygon approximation of a circle
function addCircle(cx, cy, radius)
	assert(is_initialized, "Not properly initialized!")
	local shape = CircleShape(cx,cy, radius)
	local function hash_aware_member(oldfunc)
		return function(self, ...)
			local r = vector(self._radius, self._radius)
			local c1 = self._center
			oldfunc(self, ...)
			local c2 = self._center
			hash:update(self, c1-r, c1+r, c2-r, c2+r)
		end
	end
	shape.move = hash_aware_member(shape.move)
	shape.rotate = hash_aware_member(shape.rotate)
	function shape:_getNeighbors()
		local c,r = self._center, vector(self._radius, self._radius)
		return hash:getNeighbors(self, c-r, c+r)
	end
	function shape:_removeFromHash()
		local c,r = self._center, vector(self._radius, self._radius)
		hash:remove(self, c-r, c+r)
	end

	local c,r = shape._center, vector(radius,radius)
	return new_shape(shape, c-r, c+r)
end

function addPoint(x,y)
	assert(is_initialized, "Not properly initialized!")
	local shape = PointShape(x,y)
	local function hash_aware_member(oldfunc)
		return function(self, ...)
			rawset(hash:cell(self._pos), self, nil)
			oldfunc(self, ...)
			rawset(hash:cell(self._pos), self, self)
		end
	end
	shape.move = hash_aware_member(shape.move)
	shape.rotate = hash_aware_member(shape.rotate)
	function shape:_getNeighbors()
		local set = {}
		for _,other in pairs(hash:cell(self._pos)) do
			rawset(set, other, other)
		end
		rawset(set, self, nil)
		return set
	end
	function shape:_removeFromHash()
		hash:remove(self, self._pos, self._pos)
	end

	return new_shape(shape, shape._pos, shape._pos)
end

-- get unique indentifier for an unordered pair of shapes, i.e.:
-- collision_id(s,t) = collision_id(t,s)
local function collision_id(s,t)
	local i,k = shape_ids[s], shape_ids[t]
	if i < k then i,k = k,i end
	return string.format("%d,%d", i,k)
end

local function share_group(shape, other)
	for name,group in pairs(shape._groups) do
		if group[other] then return true end
	end
	return false
end

local _love_update
function setAutoUpdate(max_step, times)
	assert(_love_update == nil, "Auto update already enabled!")

	_love_update = love.update
	love.update = function(dt)
		_love_update(dt)
		update(dt)
	end

	if type(max_step) == "number" then
		if max_step > 1 then -- assume it's a framerate
			max_step = 1 / max_step
		end
		local times = time or 1
		local combined_update = love.update
		love.update = function(dt)
			local i = 1
			while dt > max_step do
				combined_update(max_step)
				dt = dt - max_step
				i = i + 1
				if i > times then return end
			end
			combined_update(dt)
		end
	end
end

function setNoAutoUpdate()
	love.update = _love_update
	_love_update = nil
end

-- check for collisions
local colliding_last_frame = {}
function update(dt)
	-- collect colliding shapes
	local tested, colliding = {}, {}
	for _,shape in pairs(active_shapes) do
		local neighbors = shape:_getNeighbors()
		for _,other in pairs(neighbors) do
			local id = collision_id(shape,other)
			if not tested[id] then
				if not (ghosts[other] or share_group(shape, other)) then
					local collide, sep = shape:collidesWith(other)
					if collide then
						colliding[id] = {shape, other, sep.x, sep.y}
					end
					tested[id] = true
				end
			end
		end
	end

	-- call colliding callbacks on colliding shapes
	for id,info in pairs(colliding) do
		colliding_last_frame[id] = nil
		cb_collide( dt, unpack(info) )
	end

	-- call stop callback on shapes that do not collide
	-- anymore
	for _,info in pairs(colliding_last_frame) do
		cb_stop( dt, unpack(info) )
	end

	colliding_last_frame = colliding
end

-- remove shape from internal tables and the hash
function remove(shape)
	local id = shape_ids[shape]
	if id then
		active_shapes[id] = nil
		passive_shapes[id] = nil
	end
	ghosts[shape] = nil
	shape_ids[shape] = nil
	shape:_removeFromHash()
end

-- group support
function addToGroup(group, shape, ...)
	if not shape then return end
	assert(shape_ids[shape], "Shape was not created by main module!")
	if not groups[group] then groups[group] = {} end
	groups[group][shape] = true
	shape._groups[group] = groups[group]
	return addToGroup(group, ...)
end

function removeFromGroup(group, shape, ...)
	if not shape or not groups[group] then return end
	assert(shape_ids[shape], "Shape was not created by main module!")
	groups[group][shape] = nil
	shape._groups[group] = nil
	return removeFromGroup(group, ...)
end

function setPassive(shape, ...)
	if not shape then return end
	assert(shape_ids[shape], "Shape was not created by main module!")
	local id = shape_ids[shape]
	if not id or ghosts[shape] then return end

	active_shapes[id] = nil
	passive_shapes[id] = shape

	return setPassive(...)
end

function setActive(shape, ...)
	if not shape then return end
	assert(shape_ids[shape], "Shape was not created by main module!")
	local id = shape_ids[shape]
	if not id or ghosts[shape] then return end

	active_shapes[id] = shape
	passive_shapes[id] = nil

	return setActive(...)
end

function setGhost(shape, ...)
	if not shape then return end
	assert(shape_ids[shape], "Shape was not created by main module!")
	local id = shape_ids[shape]
	if not id then return end

	active_shapes[id] = nil
	passive_shapes[id] = nil
	ghosts[shape] = shape
	return setGhost(...)
end

function setSolid(shape, ...)
	if not shape then return end
	assert(shape_ids[shape], "Shape was not created by main module!")
	local id = shape_ids[shape]
	if not id then return end

	active_shapes[id] = shape
	passive_shapes[id] = nil
	ghosts[shape] = nil
	return setSolid(...)
end
