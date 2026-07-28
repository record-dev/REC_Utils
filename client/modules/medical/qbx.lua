
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

if medical ~= medicalTypes.qbx then
    return
end

local qbx_medic = exports.qbx_medical

---@type REC_Utils.Client.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local QBX_MEDICAL = {}

function QBX_MEDICAL:isLastStand()
    return qbx_medic:IsLaststand() == true
end

function QBX_MEDICAL:isDead()
    return qbx_medic:IsDead() == true
end

function QBX_MEDICAL:kill()
    SetEntityHealth(cache.ped, 0)
    return true
end

return QBX_MEDICAL