
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

---@type REC_Utils.Server.Modules.Clothing
---@diagnostic disable-next-line: missing-fields
local REC_CLOTHING = {}

-- opens the editor on the target player for free, e.g. a tailor dressing a customer
function REC_CLOTHING:giveClothing(playerId, fullCustomization)

    if isStarted() == false then
        return false
    end

    return exports.REC_Clothing:grantCustomization(playerId, {
        preset = fullCustomization == true and "full" or "clothing",
        free = true,
    }) == true
end

function REC_CLOTHING:saveOutfit(citizenId, name, clothingData)

    if isStarted() == false or citizenId == nil or name == nil or clothingData == nil then
        return false
    end

    return exports.REC_Clothing:saveOutfit(citizenId, name, clothingData) == true
end

function REC_CLOTHING:loadOutfit(citizenId, name)

    if isStarted() == false or citizenId == nil or name == nil then
        return nil
    end

    return exports.REC_Clothing:loadOutfit(citizenId, name)
end

function REC_CLOTHING:getOutfits(citizenId)

    if isStarted() == false or citizenId == nil then
        return {}
    end

    return exports.REC_Clothing:getOutfits(citizenId) or {}
end

function REC_CLOTHING:deleteOutfit(citizenId, name)

    if isStarted() == false or citizenId == nil or name == nil then
        return false
    end

    return exports.REC_Clothing:deleteOutfit(citizenId, name) == true
end

return REC_CLOTHING
