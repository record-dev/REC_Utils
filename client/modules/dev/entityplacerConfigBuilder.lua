
---@type REC_Library.Client.API, REC_Library.Shared.API
local clApi, shApi = require "@REC_Library.client.cl_api", require "@REC_Library.shared.sh_api"

---@type REC_Utils.Shared.Enum
local shEnum = require "@REC_Utils.shared.sh_enum"
local placeEntityTypes = shEnum.placeentityTypes

---@class REC_Utils.Client.Modules.Dev.EntityPlacerConfig
---@field menuID string
---@field model string
---@field placeMode "ray" | "properly"
---@field currentEntity REC_Library.Client.Class.Object.Object
---@field offsets vector3
---@field placedEntities table<integer, REC_Utils.Client.Modules.Dev.EntityPlacerConfig.PlacedEntity>
---@field onJustPressE? fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@field onJustPressBackSpace? fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@field onJustPressLeftMouse? fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@field onJustPressScrollUpMouse? fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@field onJustPressScrollDownMouse? fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@field onJustPressM? fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@field onJustPressSpace? fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@field onJustPressEnter? fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@field isActive boolean

---@class REC_Utils.Client.Modules.Dev.EntityPlacerConfigBuilder: REC_Utils.Client.Modules.Dev.EntityPlacerConfig
local EntityPlacerConfigBuilder = {}
EntityPlacerConfigBuilder.__index = EntityPlacerConfigBuilder

---@param model string
---@return self
function EntityPlacerConfigBuilder:new(model)
    local instance = setmetatable({}, self)
    instance.menuID = (("%s-ObjectPlacerMenu"):format(GetInvokingResource()))
    instance.model = model
    instance.placeMode = "ray"
    instance.currentEntity = clApi.Class.Object.Object:new(
        shApi.Class.Object.ObjectConfigBuilder:new(
            model,
            vector3(0.0, 0.0, 0.0),
            0.0
        )
        :setAlpha(100)
    )
    instance.offsets = vector3(0.0, 0.0, 0.0)
    instance.placedEntities = {}
    instance.isActive = false
    return instance
end

---@param onJustPressE fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@return self
function EntityPlacerConfigBuilder:setOnJustPressE(onJustPressE)
    if onJustPressE == nil then return self end
    self.onJustPressE = onJustPressE
    return self
end

---@param onJustPressBackSpace fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@return self
function EntityPlacerConfigBuilder:setOnJustPressBackSpace(onJustPressBackSpace)
    if onJustPressBackSpace == nil then return self end
    self.onJustPressBackSpace = onJustPressBackSpace
    return self
end

---@param onJustPressLeftMouse fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@return self
function EntityPlacerConfigBuilder:setOnJustPressLeftMouse(onJustPressLeftMouse)
    if onJustPressLeftMouse == nil then return self end
    self.onJustPressLeftMouse = onJustPressLeftMouse
    return self
end

---@param onJustPressScrollUpMouse fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@return self
function EntityPlacerConfigBuilder:setOnJustPressScrollUpMouse(onJustPressScrollUpMouse)
    if onJustPressScrollUpMouse == nil then return self end
    self.onJustPressScrollUpMouse = onJustPressScrollUpMouse
    return self
end

---@param onJustPressScrollDownMouse fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@return self
function EntityPlacerConfigBuilder:setOnJustPressScrollDownMouse(onJustPressScrollDownMouse)
    if onJustPressScrollDownMouse == nil then return self end
    self.onJustPressScrollDownMouse = onJustPressScrollDownMouse
    return self
end

---@param onJustPressM fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@return self
function EntityPlacerConfigBuilder:setOnJustPressM(onJustPressM)
    if onJustPressM == nil then return self end
    self.onJustPressM = onJustPressM
    return self
end

---@param onJustPressSpace fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@return self
function EntityPlacerConfigBuilder:setOnJustPressSpace(onJustPressSpace)
    if onJustPressSpace == nil then return self end
    self.onJustPressSpace = onJustPressSpace
    return self
end

---@param onJustPressEnter fun(self: REC_Utils.Client.Modules.Dev.EntityPlacer, )
---@return self
function EntityPlacerConfigBuilder:setOnJustPressEnter(onJustPressEnter)
    if onJustPressEnter == nil then return self end
    self.onJustPressEnter = onJustPressEnter
    return self
end

return EntityPlacerConfigBuilder

---@class REC_Utils.Client.Modules.Dev.EntityPlacerConfig.PlacedEntity
---@field handle integer
---@field model string
---@field coords vector3
---@field heading number
---@field rotation vector3
---@field particle? { dict: string, name: string, }