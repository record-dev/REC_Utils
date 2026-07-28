
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

if medical ~= medicalTypes.qb then
    return
end

---@type REC_Utils.Client.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local QB_MEDICAL = {}

function QB_MEDICAL:isLastStand()
    return false
end

function QB_MEDICAL:isDead()
    return GetEntityHealth(cache.ped) <= 0
end

function QB_MEDICAL:kill()
    SetEntityHealth(cache.ped, 0)
    return true
end

return QB_MEDICAL