
---@class REC_Utils.Client.Modules.Target.TargetOptionsConfig
---@field label string
---@field distance? number
---@field icon? string
---@field iconColor? string
---@field clientEvent? string
---@field onCanInteract? fun(...): boolean
---@field onSelect? fun(...)
---@field debugMode boolean

---@class REC_Utils.Client.Modules.Target.TargetOptionsConfigBuilder: REC_Utils.Client.Modules.Target.TargetOptionsConfig
local TargetOptionsConfigBuilder = {}
TargetOptionsConfigBuilder.__index = TargetOptionsConfigBuilder

---@param label string
---@return self
function TargetOptionsConfigBuilder:new(label)
    local instance = setmetatable({}, self)
    instance.label = label
    instance.debugMode = false
    return instance
end

---@param distance number
---@return self
function TargetOptionsConfigBuilder:setDistance(distance)
    if distance == nil then return self end
    self.distance = distance
    return self
end

---@param icon string
---@return self
function TargetOptionsConfigBuilder:setIcon(icon)
    if icon == nil then return self end
    self.icon = icon
    return self
end

---@param iconColor string
---@return self
function TargetOptionsConfigBuilder:setIconColor(iconColor)
    if iconColor == nil then return self end
    self.iconColor = iconColor
    return self
end

---@param clientEvent string
---@return self
function TargetOptionsConfigBuilder:setEvent(clientEvent)
    if clientEvent == nil then return self end
    self.clientEvent = clientEvent
    return self
end

---@param onCanInteract fun(...)
---@return self
function TargetOptionsConfigBuilder:setCanInteract(onCanInteract)
    if onCanInteract == nil then return self end
    self.onCanInteract = onCanInteract
    return self
end

---@param onSelect fun(...)
---@return self
function TargetOptionsConfigBuilder:setOnSelect(onSelect)
    if onSelect == nil then return self end
    self.onSelect = onSelect
    return self
end

---@param debugMode boolean
---@return self
function TargetOptionsConfigBuilder:setDebugMode(debugMode)
    if debugMode == nil then return self end
    self.debugMode = debugMode
    return self
end

return TargetOptionsConfigBuilder