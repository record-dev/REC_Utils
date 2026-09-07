
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

if medical ~= medicalTypes.rec then
    return
end

---@type REC_Utils.Client.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local REC_MEDICAL = {}

function REC_MEDICAL:isLastStand()
    return exports.REC_Medical:isLastStand() == true
end

function REC_MEDICAL:isDead()
    return exports.REC_Medical:isDead() == true
end

function REC_MEDICAL:kill()
    return exports.REC_Medical:kill() == true
end

return REC_MEDICAL
