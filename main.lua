local camera = require("lib.camera")
local sti = require("lib.sti")
local wf = require("lib.windfield")
local Player = require("src.Player")

local cam = camera()
local world = wf.newWorld(0, 0)
local map = sti("maps/map.lua")
local player = Player.new(world)

function love.load()
    if map.layers["Walls"] then
        for _, object in pairs(map.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(object.x, object.y, object.width, object.height)
            wall:setType("static")
        end
    end
end

function love.update(dt)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    player:update(dt)
    world:update(dt)

    cam:lookAt(player.collider:getX(), player.collider:getY())
    cam.x = math.max(cam.x, screenWidth / 2)
    cam.y = math.max(cam.y, screenHeight / 2)
    cam.x = math.min(cam.x, map.width * map.tilewidth - screenWidth / 2)
    cam.y = math.min(cam.y, map.height * map.tileheight - screenHeight / 2)
end

function love.draw()
    cam:attach()
        map:drawLayer(map.layers["Ground"])
        player:draw()
        map:drawLayer(map.layers["Trees"])
        -- world:draw()
    cam:detach()
end
