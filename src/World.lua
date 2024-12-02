local sti = require("lib.sti")
local wf = require("lib.windfield")

local World = {}
World.__index = World

function World.new()
    local self = setmetatable({}, World)
    self.collisions = wf.newWorld(0, 0)
    self.map = sti("maps/map.lua")
    return self
end

function World:initializeMapCollisions()
    if self.map.layers["Walls"] then
        for _, object in pairs(self.map.layers["Walls"].objects) do
            local wall = self.collisions:newRectangleCollider(object.x, object.y, object.width, object.height)
            wall:setType("static")
        end
    end
end

function World:initializeEntityPosition(entity, collisionClass, x, y, colliderOffset)
    entity.collider = self.collisions:newBSGRectangleCollider(x, y, entity.width - colliderOffset, entity.height - colliderOffset, 5)
    entity.collider:setCollisionClass(collisionClass)
    entity.collider:setFixedRotation(true)
end

function World:update(dt)
    self.collisions:update(dt)
end

function World:draw()
    self.map:drawLayer(self.map.layers["Base"])
    self.map:drawLayer(self.map.layers["Objects"])
end

return World
