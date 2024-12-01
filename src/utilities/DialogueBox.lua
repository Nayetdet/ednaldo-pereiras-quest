local utf8 = require("lib/utf8-lua"):init()

local DialogueBox = {}
DialogueBox.__index = DialogueBox

function DialogueBox.new(dialogueKey)
    local self = setmetatable({}, DialogueBox)
    self.dialogues = require("dialogues")[dialogueKey]
    self.dialogueIndex = 1
    self.dialogueCharIndex = 0

    self.delay = 0.05
    self.timer = self.delay

    self.offset = 25
    self.width = love.graphics.getWidth() - self.offset * 2
    self.height = 150
    
    self.typingSound = love.audio.newSource("sounds/typing-sound.ogg", "static")
    self.typingSound:setVolume(0.05)
    
    self.font = love.graphics.newFont("fonts/VT323-Regular.ttf", 36)
    love.graphics.setFont(self.font)
    return self
end

function DialogueBox:getCurrentDialogue()
    return self.dialogues[self.dialogueIndex]
end

function DialogueBox:hasNextDialogue()
    return self.dialogueIndex < #self.dialogues
end

function DialogueBox:gotoNextDialogue()
    assert(self:hasNextDialogue(), "No more dialogues available")
    self.dialogueIndex = self.dialogueIndex + 1
    self.dialogueCharIndex = 0
end

function DialogueBox:update(dt)
    if self.dialogueCharIndex < utf8.len(self:getCurrentDialogue()) then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.typingSound:stop()
            self.typingSound:play()
        
            self.dialogueCharIndex = self.dialogueCharIndex + 1
            self.timer = self.delay
        end
    end
end

function DialogueBox:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.offset, self.offset, self.width, self.height)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.offset, self.offset, self.width, self.height)

    local currentText = utf8.sub(self:getCurrentDialogue(), 1, self.dialogueCharIndex) or ""
    local currentTextHeight = #select(2, self.font:getWrap(currentText, self.width)) * self.font:getHeight()
    local currentTextY = self.offset + (self.height - currentTextHeight) / 2
    love.graphics.printf(currentText, self.offset, currentTextY, self.width, "center")
end

return DialogueBox
