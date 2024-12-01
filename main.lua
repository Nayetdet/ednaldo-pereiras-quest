local Player = require("src.Player")
local World = require("src.World")
local Camera = require("src.utilities.Camera")

local player = Player.new()
local world = World.new(player)
local cam = Camera.new(player, world)

function love.update(dt)
    player:update(dt)
    world:update(dt)
    cam:update()
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        player:interact(world)
    end
end

function love.draw()
    cam:attach()
        world:draw()
        player:draw()
        world.collisions:draw()
    cam:detach()
end
