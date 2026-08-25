
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

if medical ~= medicalTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local CUSTOM_MEDICAL = {}

function CUSTOM_MEDICAL:revive(playerId)



    return true
end

function CUSTOM_MEDICAL:kill(playerId)

    TriggerClientEvent(events.client.kill, playerId)

    return true
end

function CUSTOM_MEDICAL:isDead(playerId)

    -- exists check
    local ped = GetPlayerPed(playerId)
    if ped == 0 then
        return false
    end

    return GetEntityHealth(ped) <= 0
end

return CUSTOM_MEDICAL