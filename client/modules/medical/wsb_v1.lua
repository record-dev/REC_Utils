
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

if medical ~= medicalTypes.wsb_v1 then
    return
end

local wasabi_ambulance = exports.wasabi_ambulance

---@type REC_Utils.Client.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local WSBV1_MEDICAL = {}

function WSBV1_MEDICAL:isLastStand()
    return false
end

function WSBV1_MEDICAL:isDead()
    return wasabi_ambulance:isPlayerDead() == true
end

function WSBV1_MEDICAL:kill()
    SetEntityHealth(cache.ped, 0)
    return true
end

return WSBV1_MEDICAL