
---@class REC_Utils.Server.modules.Dispatch.ConfigBuilder
---@field title string
---@field msg string
---@field description string
---@field coords vector3
---@field duration integer
---@field jobs string[]
---@field priority "high" | "medium" | "low"
---@field sprite? integer
---@field spriteLabel? string
---@field spriteColor? integer
---@field spriteScale? number
---@field code? string
---@field codeName? string
---@field soundDict? string
---@field soudName? string
---@field icon? string
---@field iconColor? string
local DispatchConfigBuilder = {}
DispatchConfigBuilder.__index = DispatchConfigBuilder

---@param title string
---@param msg string
---@param description string
---@param coords vector3
---@param duration integer
---@param jobs string[]
---@return self
function DispatchConfigBuilder:new(title, msg, description, coords, duration, jobs)
    local instance = setmetatable({}, self)
    instance.title = title
    instance.msg = msg
    instance.description = description
    instance.coords = coords
    instance.duration = duration
    instance.jobs = jobs
    instance.soundDict = "Lose_1st"
    instance.soudName = "GTAO_FM_Events_Soundset"
    return instance
end

---@param label string
---@param sprite integer https://docs.fivem.net/docs/game-references/blips/
---@param spriteColor integer
---@param spriteScale number
---@return self
function DispatchConfigBuilder:setBlip(label, sprite, spriteColor, spriteScale)
    self.spriteLabel = label
    self.sprite = sprite
    self.spriteColor = spriteColor
    self.spriteScale = spriteScale
    return self
end

---@param code string
---@param codeName string
---@return self
function DispatchConfigBuilder:setCode(code, codeName)
    self.code = code
    return self
end

---@param priority "high" | "medium" | "low"
---@return self
function DispatchConfigBuilder:setPriority(priority)
    self.priority = priority
    return self
end

---@param icon string
---@param iconColor string
---@return self
function DispatchConfigBuilder:setIcon(icon, iconColor)
    self.icon = icon
    self.iconColor = iconColor
    return self
end

return DispatchConfigBuilder