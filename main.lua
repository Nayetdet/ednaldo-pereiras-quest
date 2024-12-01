local Player = require("src.entities.Player")
local World = require("src.World")
local Camera = require("src.utilities.Camera")
local DialogueBox = require("src.utilities.DialogueBox")

local player = Player.new()
local world = World.new(player)
local cam = Camera.new(player, world)
local currentDialogueBox = nil

local npc = Player.new()

function love.load()
    npc.collider = world.collisions:newRectangleCollider(100, 200, npc.width, npc.height)
    npc.collider:setCollisionClass("NPC")
    npc.collider:setFixedRotation(true)
    npc.collider:setType("static")
end

function love.update(dt)
    player:update(dt)
    world:update(dt)
    cam:update()

    if currentDialogueBox then
        currentDialogueBox:update(dt)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key ~= "space" then
        return
    end

    if player:isInteractingWithNPC(world) then
        currentDialogueBox = DialogueBox.new("NPC1")
        return
    end

    if currentDialogueBox and currentDialogueBox:hasNextDialogue() then
        currentDialogueBox:gotoNextDialogue()
    else
        currentDialogueBox = nil
    end
end

function love.draw()
    cam:attach()
        world:draw()
        player:draw()
        npc:draw()
        world.collisions:draw()
    cam:detach()

    if currentDialogueBox then
        currentDialogueBox:draw()
    end
end
