
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

if medical ~= medicalTypes.qb then
    return
end

---@type REC_Utils.Server.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local QB_MEDICAL = {}

function QB_MEDICAL:revive(playerId)



    return true
end

function QB_MEDICAL:kill(playerId)

    TriggerClientEvent(events.client.kill, playerId)

    return true
end

function QB_MEDICAL:isDead(playerId)
    return 
end

return QB_MEDICAL