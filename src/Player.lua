local vector = require("lib.vector")
local Animations = require("src.Animations")

local Player = {}
Player.__index = Player

Player.SPEED = 300
Player.COLLIDER_OFFSET = 20
Player.DIRECTIONS = {
    w = vector(0, -1),
    a = vector(-1, 0),
    s = vector(0, 1),
    d = vector(1, 0)
}

function Player.new(world)
    local self = setmetatable({}, Player)
    
    self.animations = Animations.new("sprites/player-sheet.png", 12, 18, 2)
    self.animations:add("w", 1, 4, 4)
    self.animations:add("a", 1, 4, 2)
    self.animations:add("s", 1, 4, 1)
    self.animations:add("d", 1, 4, 3)
    self.animations:setCurrentAnimation("d")
    
    self.direction = vector(0, 0)
    self.width = self.animations.frameWidth * Animations.FRAME_SCALE
    self.height = self.animations.frameHeight * Animations.FRAME_SCALE
    
    self.collider = world:newBSGRectangleCollider(400, 200, self.width - Player.COLLIDER_OFFSET, self.height - Player.COLLIDER_OFFSET, 10)
    self.collider:setFixedRotation(true)

    return self
end

function Player:update(dt)
    self.direction:set(0, 0)
    for key, direction in pairs(Player.DIRECTIONS) do
        if love.keyboard.isDown(key) then
            self.direction:replace(self.direction + direction)
            self.animations:setCurrentAnimation(key)
        end
    end

    if self.direction == vector(0, 0) then
        self.animations.currentAnimation:gotoFrame(self.animations.idleFrame)
    end

    self.direction:norm() -- Evita que o deslocamento na diagonal seja mais rápido
    self.direction = self.direction * Player.SPEED
    self.collider:setLinearVelocity(self.direction.x, self.direction.y)
    self.animations:update(dt)    
end

function Player:draw()
    self.animations:draw(self.collider:getX(), self.collider:getY())
end

return Player
