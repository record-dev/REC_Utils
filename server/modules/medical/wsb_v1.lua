
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

if medical ~= medicalTypes.wsb_v1 then
    return
end

local wasabi_ambulance = exports.wasabi_ambulance

---@type REC_Utils.Server.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local WSB_MEDICALV1 = {}

function WSB_MEDICALV1:revive(playerId)

    wasabi_ambulance:RevivePlayer(playerId)

    return true
end

function WSB_MEDICALV1:kill(playerId)

    TriggerClientEvent(events.client.kill, playerId)

    return true
end

function WSB_MEDICALV1:isDead(playerId)
    return 
end

return WSB_MEDICALV1