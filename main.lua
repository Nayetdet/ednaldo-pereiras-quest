local Player = require("src.entities.Player")
local World = require("src.World")
local Camera = require("src.utilities.Camera")
local DialogueManager = require("src.utilities.DialogueManager")

local player = Player.new()
local world = World.new()
local cam = Camera.new(player, world)
local dialogueManager = DialogueManager.new()

local NPC = require("src.entities.NPC")
local npc = NPC.new()

function love.load()
    world.collisions:addCollisionClass("Player")
    world.collisions:addCollisionClass("NPC")

    world:initializeMapCollisions()
    world:initializeEntityPosition(player, "Player", 100, 100, 5)

    world:initializeEntityPosition(npc, "NPC", 100, 200, 5)
    npc.collider:setType("static")
end

function love.update(dt)
    player:update(dt)
    world:update(dt)
    cam:update(dt)
    dialogueManager:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key ~= "space" then
        return
    end

    if player:isInteractingWithNPC(world) then
        dialogueManager:add("2")
    else
        dialogueManager:interact()
    end
end

function love.draw()
    cam:attach()
        world:draw()
        player:draw()
        npc:draw()
        -- world.collisions:draw()
    cam:detach()
    dialogueManager:draw()
end
