
---@type REC_Library.Client.API, REC_Library.Shared.API
local clApi, shApi = require "@REC_Library.client.cl_api", require "@REC_Library.shared.sh_api"

---@type REC_Utils.Shared.Enum
local shEnum = require "@REC_Utils.shared.sh_enum"
local placeEntityTypes = shEnum.placeentityTypes

---@type REC_Utils.Client.Modules.Raycast
local RayCast = require "@REC_Utils.client.modules.raycast"

---@class REC_Utils.Client.Modules.Dev.EntityPlacer
---@field info REC_Utils.Client.Modules.Dev.EntityPlacerConfig
local EntityPlacer = {}
EntityPlacer.__index = EntityPlacer

---@param config REC_Utils.Client.Modules.Dev.EntityPlacerConfig
---@return self
function EntityPlacer:new(config)
    local instance = setmetatable({}, self)
    instance.info = config
    return instance
end

function EntityPlacer:broadcast()
    local info = self.info

    if info.isActive == true then
        print("^3Already active...^0")
        return
    end

    Citizen.CreateThread(function (threadId)

        info.isActive = true
        RayCast:toggle(true)

        if info.currentEntity:spawn() == false then
            print("^3Failed to spawn entity for broadcasting raycast result...^0")
            return
        end

        SetEntityCompletelyDisableCollision(info.currentEntity:getHandle(), false, false)
        SetPedConfigFlag(cache.ped, 122, true) -- Disable punch

        while info.isActive == true do
            Citizen.Wait(0)
            local currentEntityHandle = info.currentEntity:getHandle()

            local result = RayCast:getResult()
            if result ~= nil and result.endCoords ~= nil then

                if info.placeMode == "ray" then
                    -- if result.hit == false then
                    --     SetEntityAlpha(currentEntityHandle, 100, false)
                    -- else
                    --     SetEntityAlpha(currentEntityHandle, 0, false)
                    -- end

                    SetEntityCoords(
                        currentEntityHandle,
                        result.endCoords.x,
                        result.endCoords.y,
                        result.endCoords.z,
                        false,
                        false,
                        false,
                        false
                    )
                else
                    -- if result.hit == false then
                    --     SetEntityAlpha(currentEntityHandle, 100, false)
                    -- else
                    --     SetEntityAlpha(currentEntityHandle, 0, false)
                    -- end

                    SetEntityCoords(
                        currentEntityHandle,
                        result.endCoords.x,
                        result.endCoords.y,
                        result.endCoords.z,
                        false,
                        false,
                        false,
                        false
                    )

                    PlaceObjectOnGroundProperly(currentEntityHandle)
                end

                -- E
                if IsControlJustPressed(0, 51) == 1 then
                    info.onJustPressE(self)
                end

                -- Back Space
                if IsControlJustPressed(0, 177) == 1 and info.onJustPressBackSpace ~= nil then
                    info.onJustPressBackSpace(self)
                end

                -- Scroll Up Mouse
                if IsControlJustPressed(0, 241) == 1 and info.onJustPressScrollUpMouse ~= nil then
                    info.onJustPressScrollUpMouse(self)
                end

                -- Scroll Down Mouse
                if IsControlJustPressed(0, 242) == 1 and info.onJustPressScrollDownMouse ~= nil then
                    info.onJustPressScrollDownMouse(self)
                end

                -- Left Mouse
                if IsControlJustPressed(0, 24) == 1 and info.onJustPressLeftMouse ~= nil then
                    info.onJustPressLeftMouse(self)
                end

                -- M
                if IsControlJustPressed(0, 244) == 1 and info.onJustPressM ~= nil then
                    info.onJustPressM(self)
                end

                -- Space
                if IsControlJustPressed(0, 22) == 1 and info.onJustPressSpace ~= nil then
                    info.onJustPressSpace(self)
                end

                -- Shift + Enter
                if IsControlPressed(0, 21) == 1 and IsControlJustPressed(0, 201) == 1 and info.onJustPressEnter ~= nil then
                    info.onJustPressEnter(self)
                end
            end
        end

        if info.currentEntity:destroy() == false then
            print("^3Failed to destroy entity for broadcasting raycast result...^0")
        end

        self:setIsActive(false)
        SetPedConfigFlag(cache.ped, 122, false)
        SetPedConfigFlag(cache.ped, 122, false)

        RayCast:toggle(false)
    end)
end

function EntityPlacer:setIsActive(bool)
    if bool == true and self:getIsActive() == false then
        self:broadcast()
    end

    self.info.isActive = bool
end

---@param model string
---@return boolean
function EntityPlacer:setCurrentModel(model)
    local info = self.info

    local entity = clApi.Class.Object.Object:new(
        shApi.Class.Object.ObjectConfigBuilder:new(
            model,
            vector3(0.0, 0.0, 0.0),
            0.0
        )
        :setAlpha(100)
    )

    if entity:spawn() == false then
        print(("^1failed to spawn entity... model: %s^0"):format(model))
        return false
    end

    SetEntityCompletelyDisableCollision(entity:getHandle(), false, false)

    info.currentEntity:destroy()

    info.model = model
    info.currentEntity = entity

    return true
end

function EntityPlacer:togglePlaceMode()
    self.info.placeMode = (function ()
        if self.info.placeMode == "ray" then
            return "properly"
        else
            return "ray"
        end
    end)()
end

---@return table<integer, REC_Utils.Client.Modules.Dev.EntityPlacerConfig.PlacedEntity>
function EntityPlacer:getPlacedEntities()
    return self.info.placedEntities
end

function EntityPlacer:destroyPlacedEntities()
    for _, entity in ipairs(self.info.placedEntities) do
        DeleteEntity(entity.handle)
    end
    self.info.placedEntities = {}
end

---@return boolean
function EntityPlacer:getIsActive()
    return self.info.isActive
end

---@return REC_Library.Client.Class.Object.Object
function EntityPlacer:getCurrentEntity()
    return self.info.currentEntity
end

---@return "ray" | "properly"
function EntityPlacer:getPlaceMode()
    return self.info.placeMode
end

---@return string
function EntityPlacer:getCurrentModel()
    return self.info.currentEntity.info.model
end

function EntityPlacer:getRayCastResult()
    return RayCast:getResult()
end

---@param metadata REC_Utils.Client.Modules.Dev.EntityPlacerConfig.PlacedEntity
function EntityPlacer:addPlacedEntity(metadata)
    self.info.placedEntities[#self.info.placedEntities+1] = metadata
end

return EntityPlacer
