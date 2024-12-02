local BaseEntity = require("src.entities.BaseEntity")

local NPC = {}
NPC.__index = NPC
setmetatable(NPC, {__index = BaseEntity})

function NPC.new()
    local self = setmetatable(BaseEntity.new("sprites/player-sheet.png", 16, 24), NPC)
    self.animations:add("down", 1, 4, 1)
    self.animations:setCurrentAnimation("down")
    return self
end

return NPC
