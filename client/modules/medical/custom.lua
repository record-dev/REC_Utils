
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

if medical ~= medicalTypes.custom then
    return
end

---@type REC_Utils.Client.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local CUSTOM_MEDICAL = {}

function CUSTOM_MEDICAL:isLastStand()
    -- 瀕死状態の概念が無いので常に false
    return false
end

function CUSTOM_MEDICAL:isDead()
    return GetEntityHealth(cache.ped) <= 0
end

function CUSTOM_MEDICAL:kill()
    SetEntityHealth(cache.ped, 0)
    return true
end

return CUSTOM_MEDICAL