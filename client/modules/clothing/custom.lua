
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local clothing = apiShCfg.clothing

local apiShEnums = shApi.Enums
local clothingTypes = apiShEnums.ClothingTypes

if clothing ~= clothingTypes.custom then
    return
end

---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

-- standard ped component ids, and the prop ids worth reading back (hat, glasses, ear, watch, bracelet)
local COMPONENT_IDS = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
local PROP_IDS = { 0, 1, 2, 6, 7 }

---@type REC_Utils.Client.Modules.Clothing
---@diagnostic disable-next-line: missing-fields
local CUSTOM_CLOTHING = {}

function CUSTOM_CLOTHING:getClothing()
    local ped = cache.ped
    local clothingData = { components = {}, props = {} }

    for _, componentId in ipairs(COMPONENT_IDS) do
        clothingData.components[componentId] = {
            drawable = GetPedDrawableVariation(ped, componentId),
            texture  = GetPedTextureVariation(ped, componentId),
        }
    end

    for _, propId in ipairs(PROP_IDS) do
        clothingData.props[propId] = {
            drawable = GetPedPropIndex(ped, propId),
            texture  = GetPedPropTextureIndex(ped, propId),
        }
    end

    return clothingData
end

function CUSTOM_CLOTHING:setClothing(clothingData)
    local ped = cache.ped

    if clothingData.components ~= nil then
        for componentId, variation in pairs(clothingData.components) do
            SetPedComponentVariation(ped, componentId, variation.drawable, variation.texture, 0)
        end
    end

    if clothingData.props ~= nil then
        for propId, variation in pairs(clothingData.props) do
            if variation.drawable == -1 then
                ClearPedProp(ped, propId)
            else
                SetPedPropIndex(ped, propId, variation.drawable, variation.texture, true)
            end
        end
    end

    return true
end

-- no appearance resource installed, there is no menu to draw
function CUSTOM_CLOTHING:openMenu(cb)
    if cb ~= nil then
        cb(false)
    end
    return false
end

function CUSTOM_CLOTHING:saveOutfit(name)
    TriggerServerEvent(events.server.clothingSaveOutfit, name, CUSTOM_CLOTHING:getClothing())
    return true
end

function CUSTOM_CLOTHING:loadOutfit(name)
    TriggerServerEvent(events.server.clothingRequestOutfit, name)
    return true
end

return CUSTOM_CLOTHING
