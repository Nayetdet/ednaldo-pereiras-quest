local Animations = require("src.utilities.Animations")
local vector = require("lib.vector")

local Player = {}
Player.__index = Player

function Player.new()
    local self = setmetatable({}, Player)
    self.direction = vector(0, 0)
    self.speed = 80
    self.width = 16
    self.height = 24
    self.collider = nil
    self.animations = self:initializeAnimations(self.width, self.height)
    return self
end

function Player:initializeAnimations(width, height)
    local animations = Animations.new("sprites/player-sheet.png", width, height, 1)
    animations:add("down", 1, 4, 1)
    animations:add("up", 1, 4, 2)
    animations:add("left", 1, 4, 4)
    animations:add("right", 1, 4, 3)
    animations:setCurrentAnimation("down")
    return animations
end

function Player:update(dt)
    local directions = {
        {name = "down", key = "s", vector = vector(0, 1)},
        {name = "up", key = "w", vector = vector(0, -1)},
        {name = "left", key = "a", vector = vector(-1, 0)},
        {name = "right", key = "d", vector = vector(1, 0)},
    }
    
    local movimentDirection = vector(0, 0)
    for _, direction in ipairs(directions) do
        if love.keyboard.isDown(direction.key) then
            movimentDirection:replace(movimentDirection + direction.vector)
            self.direction:replace(direction.vector)
            self.animations:setCurrentAnimation(direction.name)
        end
    end
    
    if movimentDirection == vector(0, 0) then
        self.animations.currentAnimation:gotoFrame(self.animations.idleFrame)
    end
    
    self.collider:setLinearVelocity((movimentDirection:norm() * self.speed):unpack())
    self.animations:update(dt)
end

function Player:isInteractingWithNPC(world)
    local queryPosition = self:getPosition() + self.direction * vector(self.width, self.height) / 2
    local colliders = world.collisions:queryCircleArea(queryPosition.x, queryPosition.y, 5, {"NPC"})
    return #colliders > 0
end

function Player:getPosition()
    return vector(self.collider:getPosition())
end

function Player:draw()
    self.animations:draw(self:getPosition():unpack())
end

return Player
