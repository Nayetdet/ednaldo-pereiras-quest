local Player = require("src.entities.Player")
local World = require("src.World")
local Camera = require("src.utilities.Camera")
local DialogueBox = require("src.utilities.DialogueBox")

local player = Player.new()
local world = World.new()
local cam = Camera.new(player, world)
local dialogueBox = nil

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
    cam:update()

    if dialogueBox then
        dialogueBox:update(dt)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key ~= "space" then
        return
    end

    if player:isInteractingWithNPC(world) then
        dialogueBox = DialogueBox.new("NPC2")
        return
    end

    if dialogueBox and dialogueBox:hasNextDialogue() then
        dialogueBox:gotoNextDialogue()
    else
        dialogueBox = nil
    end
end

function love.draw()
    cam:attach()
        world:draw()
        player:draw()
        npc:draw()
        world.collisions:draw()
    cam:detach()

    if dialogueBox then
        dialogueBox:draw()
    end
end
