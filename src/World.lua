local sti = require("lib.sti")
local wf = require("lib.windfield")

local World = {}
World.__index = World

function World.new(player)
    local self = setmetatable({}, World)
    self.player = player
    self.collisions = wf.newWorld(0, 0)
    self.map = sti("maps/map.lua")
    self:initializeCollisions()
    return self
end

function World:initializeCollisions()
    self.collisions:addCollisionClass("Player")
    self.collisions:addCollisionClass("NPC")

    self:initializeMapCollisions()
    self:initializePlayerCollision(100, 100, 5)
end

function World:initializeMapCollisions()
    if self.map.layers["Walls"] then
        for _, object in pairs(self.map.layers["Walls"].objects) do
            local wall = self.collisions:newRectangleCollider(object.x, object.y, object.width, object.height)
            wall:setType("static")
        end
    end
end

function World:initializePlayerCollision(startX, startY, colliderOffset)
    self.player.collider = self.collisions:newBSGRectangleCollider(startX, startY, self.player.width - colliderOffset, self.player.height - colliderOffset, 5)
    self.player.collider:setCollisionClass("Player")
    self.player.collider:setFixedRotation(true)
end

function World:update(dt)
    self.collisions:update(dt)
end

function World:draw()
    self.map:drawLayer(self.map.layers["Base"])
    self.map:drawLayer(self.map.layers["Objects"])
end

return World
