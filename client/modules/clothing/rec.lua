
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local clothing = apiShCfg.clothing

local apiShEnums = shApi.Enums
local clothingTypes = apiShEnums.ClothingTypes

if clothing ~= clothingTypes.rec then
    return
end

---[[
---     REC_Clothing is detected while it is installed, not only started, so every
---     call checks the state and does nothing while it is stopped.
---]]
---@return boolean
local function isStarted()
    return GetResourceState("REC_Clothing") == "started"
end

---@type REC_Utils.Client.Modules.Clothing
---@diagnostic disable-next-line: missing-fields
local REC_CLOTHING = {}

function REC_CLOTHING:getClothing()

    if isStarted() == false then
        return nil
    end

    return exports.REC_Clothing:getPedAppearance(cache.ped)
end

-- a full appearance (model / head blend) changes the ped, anything else is an outfit
function REC_CLOTHING:setClothing(clothingData)

    if isStarted() == false or type(clothingData) ~= "table" then
        return false
    end

    if clothingData.model ~= nil or clothingData.headBlend ~= nil then
        exports.REC_Clothing:setPlayerAppearance(clothingData)
        return true
    end

    return exports.REC_Clothing:applyOutfit(clothingData) == true
end

-- fullCustomization asks for every tab, REC_Clothing still caps it with config.compat.clientTabs
function REC_CLOTHING:openMenu(cb, fullCustomization)

    if isStarted() == false then
        if cb ~= nil then
            cb(false)
        end
        return false
    end

    return exports.REC_Clothing:openCustomization({
        preset = fullCustomization == true and "full" or "clothing",
    }, cb)
end

function REC_CLOTHING:saveOutfit(name)

    if isStarted() == false then
        return false
    end

    return exports.REC_Clothing:saveOutfit(name) == true
end

function REC_CLOTHING:loadOutfit(name)

    if isStarted() == false then
        return false
    end

    return exports.REC_Clothing:loadOutfit(name) == true
end

return REC_CLOTHING
