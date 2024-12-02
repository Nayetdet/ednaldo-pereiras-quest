local Animations = require("src.utilities.Animations")
local BaseEntity = require("src.entities.BaseEntity")
local vector = require("lib.vector")

local Player = {}
Player.__index = Player
setmetatable(Player, {__index = BaseEntity})

function Player.new()
    local self = setmetatable(BaseEntity.new("sprites/player-sheet.png", 16, 24), Player)
    self.animations:add("down", 1, 4, 1)
    self.animations:add("up", 1, 4, 2)
    self.animations:add("left", 1, 4, 4)
    self.animations:add("right", 1, 4, 3)
    self.animations:setCurrentAnimation("down")
    return self
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
        self.animations.currentAnimation:gotoFrame(1)
    end
    
    self.collider:setLinearVelocity((movimentDirection:norm() * self.speed):unpack())
    self.animations:update(dt)
end

function Player:isInteractingWithNPC(world)
    local queryPosition = self:getPosition() + self.direction * vector(self.width, self.height) / 2
    local colliders = world.collisions:queryCircleArea(queryPosition.x, queryPosition.y, 5, {"NPC"})
    return #colliders > 0
end

return Player
