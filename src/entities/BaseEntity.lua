local Animations = require("src.utilities.Animations")
local vector = require("lib.vector")

local BaseEntity = {}
BaseEntity.__index = BaseEntity

function BaseEntity.new(spriteSheetPath, width, height)
    local self = setmetatable({}, BaseEntity)
    self.direction = vector(0, 0)
    self.speed = 80
    self.width = width
    self.height = height
    self.animations = Animations.new(spriteSheetPath, width, height)
    self.collider = nil
    return self
end

function BaseEntity:getPosition()
    assert(self.collider, "Entity has no collider attached")
    return vector(self.collider:getPosition())
end

function BaseEntity:draw()
    self.animations:draw(self:getPosition():unpack())
end

return BaseEntity
