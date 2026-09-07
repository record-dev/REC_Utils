
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local clothing = apiShCfg.clothing

local apiShEnums = shApi.Enums
local clothingTypes = apiShEnums.ClothingTypes

if clothing ~= clothingTypes.rcore then
    return
end

---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

---@type REC_Utils.Client.Modules.Clothing
---@diagnostic disable-next-line: missing-fields
local RCORE_CLOTHING = {}

-- includeCharacter false keeps the shape symmetric with setPlayerSkin, model info is not our concern here
function RCORE_CLOTHING:getClothing()
    return exports["rcore_clothing"]:getPlayerSkin(false)
end

function RCORE_CLOTHING:setClothing(clothingData)
    exports["rcore_clothing"]:setPlayerSkin(clothingData, false)
    return true
end

-- rcore_clothing has no export that returns the result synchronously, so we
-- listen once for the menu it actually opens to close before calling cb
function RCORE_CLOTHING:openMenu(cb, fullCustomization)
    if cb ~= nil then
        local closedEvent = fullCustomization == true and "rcore_clothing:charcreator:done" or "rcore_clothing:onClothingShopClosed"
        local handler

        handler = AddEventHandler(closedEvent, function ()
            RemoveEventHandler(handler)
            cb(RCORE_CLOTHING:getClothing())
        end)
    end

    TriggerEvent(fullCustomization == true and "rcore_clothing:openCharCreator" or "rcore_clothing:openChangingRoom")

    return true
end

function RCORE_CLOTHING:saveOutfit(name)
    TriggerServerEvent(events.server.clothingSaveOutfit, name, RCORE_CLOTHING:getClothing())
    return true
end

function RCORE_CLOTHING:loadOutfit(name)
    TriggerServerEvent(events.server.clothingRequestOutfit, name)
    return true
end

return RCORE_CLOTHING
