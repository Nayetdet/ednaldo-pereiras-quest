local anim8 = require("lib.anim8")
local vector = require("lib.vector")

local Animations = {}
Animations.__index = Animations

Animations.FRAME_DELAY = 0.2
Animations.FRAME_SCALE = 6

function Animations.new(spriteSheetPath, frameWidth, frameHeight, idleFrame)
    local self = setmetatable({}, Animations)
    
    self.spriteSheet = love.graphics.newImage(spriteSheetPath)
    self.spriteSheet:setFilter("nearest", "nearest")

    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.idleFrame = idleFrame

    self.grid = anim8.newGrid(
        self.frameWidth,
        self.frameHeight,
        self.spriteSheet:getWidth(),
        self.spriteSheet:getHeight()
    )
    
    self.collection = {}
    self.currentAnimation = nil

    return self
end

function Animations:add(name, frameStart, frameEnd, row)
    local frameRange = tostring(frameStart) .. "-" .. tostring(frameEnd)
    self.collection[name] = anim8.newAnimation(self.grid(frameRange, row), Animations.FRAME_DELAY)
end

function Animations:setCurrentAnimation(name)
    assert(self.collection[name], "Animation '" .. name .. "' not found in the collection.")
    self.currentAnimation = self.collection[name]
end

function Animations:update(dt)
    assert(self.currentAnimation, "No active animation to update")
    self.currentAnimation:update(dt)
end

function Animations:draw(x, y)
    assert(self.currentAnimation, "No active animation to draw.")
    local offset = vector(self.frameWidth, frameHeight) / 2
    self.currentAnimation:draw(self.spriteSheet, x, y, nil, Animations.FRAME_SCALE, nil, offset.x, offset.x)
end

return Animations
