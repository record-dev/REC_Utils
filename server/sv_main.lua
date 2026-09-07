
---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

---@type REC_Utils.Server.Api
local svUtilsApi = require "@REC_Utils.server.sv_api"

RegisterNetEvent(events.server.clothingSaveOutfit, function (name, clothingData)
    local src = source

    if svUtilsApi.Framework.getCitizenIdByPlayerId == nil then
        return
    end

    local citizenId = svUtilsApi.Framework:getCitizenIdByPlayerId(src)
    if citizenId == nil then
        return
    end

    svUtilsApi.Clothing:saveOutfit(citizenId, name, clothingData)
end)

RegisterNetEvent(events.server.clothingRequestOutfit, function (name)
    local src = source

    if svUtilsApi.Framework.getCitizenIdByPlayerId == nil then
        return
    end

    local citizenId = svUtilsApi.Framework:getCitizenIdByPlayerId(src)
    if citizenId == nil then
        return
    end

    local clothingData = svUtilsApi.Clothing:loadOutfit(citizenId, name)
    if clothingData ~= nil then
        TriggerClientEvent(events.client.clothingLoadOutfit, src, clothingData)
    end
end)
