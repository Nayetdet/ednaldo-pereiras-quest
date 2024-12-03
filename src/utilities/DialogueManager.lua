local utf8 = require("lib/utf8-lua"):init()

local DialogueManager = {}
DialogueManager.__index = DialogueManager

function DialogueManager.new()
    local self = setmetatable({}, DialogueManager)
    self.dialogues = nil
    self.dialogueIndex = 1
    self.dialogueCharIndex = 0

    self.delay = 0.05
    self.timer = 0
    
    self.font = love.graphics.newFont("fonts/VT323-Regular.ttf", 36)
    self.typingSound = love.audio.newSource("sounds/typing-sound.ogg", "static")
    self.typingSound:setVolume(0.05)
    return self
end

function DialogueManager:hasCompletedAllDialogues()
    return not self.dialogues or self.dialogueIndex > #self.dialogues
end

function DialogueManager:getCurrentDialogue()
    if self:hasCompletedAllDialogues() then
        return nil
    end

    return self.dialogues[self.dialogueIndex]
end

function DialogueManager:hasCompletedCurrentDialogue()
    local currentDialogue = self:getCurrentDialogue()
    if not currentDialogue then
        return true
    end

    return self.dialogueCharIndex >= utf8.len(currentDialogue)
end

function DialogueManager:add(dialogueKey)
    local dialoguesPath = "dialogues"
    local dialogues = require(dialoguesPath)[dialogueKey]
    assert(dialogues, "Dialogue with key '" .. dialogueKey .. "' not found in '" .. dialoguesPath .. "'")

    self.dialogues = dialogues
    self.dialogueIndex = 1
    self.dialogueCharIndex = 0
end

function DialogueManager:update(dt)
    if not self:hasCompletedCurrentDialogue() then
        self.timer = self.timer + dt
        if self.timer >= self.delay then
            self.typingSound:play() 
            self.dialogueCharIndex = self.dialogueCharIndex + 1
            self.timer = 0
        end
    end
end

function DialogueManager:interact()
    if not self:hasCompletedCurrentDialogue() then
        self.typingSound:play() 
        self.dialogueCharIndex = utf8.len(self:getCurrentDialogue())
    elseif not self:hasCompletedAllDialogues() then
        self.dialogueIndex = self.dialogueIndex + 1
        self.dialogueCharIndex = 0
    end
end

function DialogueManager:draw()
    if self:hasCompletedAllDialogues() then
        return
    end

    local margin = 25
    local borderThickness = 3
    local boxWidth = love.graphics.getWidth() - margin * 2
    local boxHeight = 150

    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", margin, margin, boxWidth, boxHeight)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(borderThickness)
    love.graphics.rectangle("line", margin, margin, boxWidth, boxHeight)

    local currentText = utf8.sub(self:getCurrentDialogue(), 1, self.dialogueCharIndex) or ""
    local textHeight = #select(2, self.font:getWrap(currentText, boxWidth)) * self.font:getHeight()
    local textYPosition = margin + (boxHeight - textHeight) / 2

    love.graphics.setFont(self.font)
    love.graphics.printf(currentText, margin, textYPosition, boxWidth, "center")
end

return DialogueManager
