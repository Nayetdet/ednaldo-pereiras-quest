local camera = require("lib.camera")

local Camera = {}
Camera.__index = Camera

function Camera.new(player, world)
    local self = setmetatable({}, Camera)
    self.base = camera()
    self.scaleFactor = love.graphics.getWidth() * (6.25 / 1200)
    self.base:zoomTo(self.scaleFactor)

    self.player = player
    self.world = world
    return self
end

function Camera:update()
    self.base:lookAt(self.player.collider:getPosition())
    self:keepCameraWithinMap()
end

function Camera:keepCameraWithinMap()
    local viewportWidth = love.graphics.getWidth() / self.scaleFactor
    local viewportHeight = love.graphics.getHeight() / self.scaleFactor

    local mapWidth = self.world.map.width * self.world.map.tilewidth
    local mapHeight = self.world.map.height * self.world.map.tileheight

    self.base.x = math.max(self.base.x, viewportWidth / 2)
    self.base.y = math.max(self.base.y, viewportHeight / 2)
    self.base.x = math.min(self.base.x, mapWidth - viewportWidth / 2)
    self.base.y = math.min(self.base.y, mapHeight - viewportHeight / 2)
end

function Camera:attach()
    self.base:attach()
end

function Camera:detach()
    self.base:detach()
end

return Camera
