
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local clothing = apiShCfg.clothing

local apiShEnums = shApi.Enums
local clothingTypes = apiShEnums.ClothingTypes

if clothing ~= clothingTypes.illenium then
    return
end

---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

---@type REC_Utils.Client.Modules.Clothing
---@diagnostic disable-next-line: missing-fields
local ILLENIUM_CLOTHING = {}

function ILLENIUM_CLOTHING:getClothing()
    return exports["illenium-appearance"]:getPedAppearance(cache.ped)
end

function ILLENIUM_CLOTHING:setClothing(clothingData)
    exports["illenium-appearance"]:setPlayerAppearance(clothingData)
    return true
end

-- fullCustomization also opens the ped/face options, default only opens components and props
function ILLENIUM_CLOTHING:openMenu(cb, fullCustomization)
    exports["illenium-appearance"]:startPlayerCustomization(function (appearance)
        if cb ~= nil then
            cb(appearance)
        end
    end, {
        ped          = fullCustomization == true,
        headBlend    = fullCustomization == true,
        faceFeatures = fullCustomization == true,
        headOverlays = fullCustomization == true,
        tattoos      = fullCustomization == true,
        components   = true,
        props        = true,
    })
    return true
end

function ILLENIUM_CLOTHING:saveOutfit(name)
    TriggerServerEvent(events.server.clothingSaveOutfit, name, ILLENIUM_CLOTHING:getClothing())
    return true
end

function ILLENIUM_CLOTHING:loadOutfit(name)
    TriggerServerEvent(events.server.clothingRequestOutfit, name)
    return true
end

return ILLENIUM_CLOTHING
