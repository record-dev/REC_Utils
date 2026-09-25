
---@class REC_Utils.Server.modules.Dispatch.ConfigBuilder
---@field title string
---@field msg string
---@field description string
---@field coords vector3
---@field duration integer ms
---@field jobs string[]
---@field priority "high" | "medium" | "low"
---@field radius? number
---@field sprite? integer
---@field spriteLabel? string
---@field spriteColor? integer
---@field spriteScale? number
---@field code? string
---@field codeName? string
---@field soundDict? string
---@field soundName? string
---@field icon? string
---@field iconColor? string
local DispatchConfigBuilder = {}
DispatchConfigBuilder.__index = DispatchConfigBuilder

---@param title string
---@param msg string
---@param description string
---@param coords vector3
---@param duration integer ms
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
    instance.priority = "medium"
    instance.radius = nil
    instance.sprite = nil
    instance.spriteLabel = nil
    instance.spriteColor = nil
    instance.spriteScale = nil
    instance.code = nil
    instance.codeName = nil
    instance.soundDict = nil
    instance.soundName = nil
    instance.icon = nil
    instance.iconColor = nil
    return instance
end

---@param label string|nil
---@param sprite integer|nil https://docs.fivem.net/docs/game-references/blips/
---@param spriteColor integer|nil
---@param spriteScale number|nil
---@return self
function DispatchConfigBuilder:setBlip(label, sprite, spriteColor, spriteScale)
    if label ~= nil then
        assert(type(label) == "string", "label must be string")
        self.spriteLabel = label
    end
    if sprite ~= nil then
        assert(type(sprite) == "number" and sprite >= 0, "sprite must be number")
        self.sprite = sprite
    end
    if spriteColor ~= nil then
        assert(type(spriteColor) == "number" and spriteColor >= 0, "spriteColor must be number")
        self.spriteColor = spriteColor
    end
    if spriteScale ~= nil then
        assert(type(spriteScale) == "number" and spriteScale >= 0, "spriteScale must be number")
        self.spriteScale = spriteScale
    end
    return self
end

---@param code string|nil
---@param codeName string|nil
---@return self
function DispatchConfigBuilder:setCode(code, codeName)
    if code ~= nil then
        assert(type(code) == "string", "code must be string")
        self.code = code
    end
    if codeName ~= nil then
        assert(type(codeName) == "string", "codeName must be string")
        self.codeName = codeName
    end
    return self
end

---@param priority "high" | "medium" | "low" | nil
---@return self
function DispatchConfigBuilder:setPriority(priority)
    if priority == nil then return self end
    assert(priority == "high" or priority == "medium" or priority == "low", "priority must be high, medium or low")
    self.priority = priority return self
end

---@param icon string|nil
---@param iconColor string|nil
---@return self
function DispatchConfigBuilder:setIcon(icon, iconColor)
    if icon ~= nil then
        assert(type(icon) == "string", "icon must be string")
        self.icon = icon
    end
    if iconColor ~= nil then
        assert(type(iconColor) == "string", "iconColor must be string")
        self.iconColor = iconColor
    end
    return self
end

---@param soundName string|nil
---@param soundSet string|nil
---@return self
function DispatchConfigBuilder:setSound(soundName, soundSet)
    if soundName == nil then return self end
    assert(type(soundName) == "string", "soundName must be string")
    assert(type(soundSet) == "string", "soundSet must be string")
    self.soundName, self.soundDict = soundName, soundSet
    return self
end

---lb-tablet and ps-dispatch ignore this
---@param radius number|nil
---@return self
function DispatchConfigBuilder:setRadius(radius)
    if radius == nil then return self end
    assert(type(radius) == "number" and radius >= 0, "radius must be number")
    self.radius = radius return self
end

return DispatchConfigBuilder
