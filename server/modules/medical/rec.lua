
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

if medical ~= medicalTypes.rec then
    return
end

---@type REC_Utils.Server.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local REC_MEDICAL = {}

function REC_MEDICAL:revive(playerId)
    return exports.REC_Medical:revive(playerId) == true
end

function REC_MEDICAL:kill(playerId)
    return exports.REC_Medical:kill(playerId) == true
end

function REC_MEDICAL:isLastStand(playerId)
    return exports.REC_Medical:isLastStand(playerId) == true
end

function REC_MEDICAL:isDead(playerId)
    return exports.REC_Medical:isDead(playerId) == true
end

return REC_MEDICAL
