
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

---@type REC_Utils.Server.Modules.Clothing
---@diagnostic disable-next-line: missing-fields
local RCORE_CLOTHING = {}

---@param citizenId string
---@param name string
local function outfitKvpKey(citizenId, name)
    return ("REC_Utils:clothing:outfit:%s:%s"):format(citizenId, name)
end

-- opens the clothing menu on the target player, e.g. a tailor dressing a customer
function RCORE_CLOTHING:giveClothing(playerId, fullCustomization)
    TriggerClientEvent(events.client.clothingOpenMenu, playerId, fullCustomization == true)
    return true
end

function RCORE_CLOTHING:saveOutfit(citizenId, name, clothingData)
    if citizenId == nil or name == nil or clothingData == nil then
        return false
    end

    SetResourceKvp(outfitKvpKey(citizenId, name), json.encode(clothingData))
    return true
end

function RCORE_CLOTHING:loadOutfit(citizenId, name)
    if citizenId == nil or name == nil then
        return nil
    end

    local raw = GetResourceKvpString(outfitKvpKey(citizenId, name))
    if raw == nil then
        return nil
    end

    return json.decode(raw)
end

function RCORE_CLOTHING:getOutfits(citizenId)
    local prefix = ("REC_Utils:clothing:outfit:%s:"):format(citizenId)
    local outfits = {}

    local handle = StartFindKvp(prefix)
    if handle == -1 then
        return outfits
    end

    while true do
        local key = FindKvp(handle)
        if key == nil then
            break
        end

        outfits[#outfits + 1] = key:sub(#prefix + 1)
    end

    EndFindKvp(handle)

    return outfits
end

function RCORE_CLOTHING:deleteOutfit(citizenId, name)
    if citizenId == nil or name == nil then
        return false
    end

    DeleteResourceKvp(outfitKvpKey(citizenId, name))
    return true
end

return RCORE_CLOTHING
