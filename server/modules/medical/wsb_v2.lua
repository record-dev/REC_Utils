
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

if medical ~= medicalTypes.wsb_v2 then
    return
end

local wasabi_ambulance_v2 = exports.wasabi_ambulance_v2

---@type REC_Utils.Server.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local WSB_MEDICALV2 = {}

function WSB_MEDICALV2:revive(playerId)

    wasabi_ambulance_v2:RevivePlayer(playerId)

    return true
end

function WSB_MEDICALV2:kill(playerId)

    TriggerClientEvent(events.client.kill, playerId)

    return true
end

function WSB_MEDICALV2:isDead(playerId)
    return wasabi_ambulance_v2:isPlayerInDistress(playerId)
end

return WSB_MEDICALV2