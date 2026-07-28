
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

if medical ~= medicalTypes.wsb_v2 then
    return
end

local wasabi_ambulance_v2 = exports.wasabi_ambulance_v2

---@type REC_Utils.Client.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local WSBV2_MEDICAL = {}

function WSBV2_MEDICAL:isLastStand()
    return false
end

function WSBV2_MEDICAL:isDead()
    return wasabi_ambulance_v2:isPlayerDead() == true
end

function WSBV2_MEDICAL:kill()
    SetEntityHealth(cache.ped, 0)
    return true
end

return WSBV2_MEDICAL