
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

local hasWarnedIsDead = false

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

function WSB_MEDICALV1:isLastStand(playerId)
    -- no last stand state here, so always false
    return false
end

function WSB_MEDICALV1:isDead(playerId)

    -- same export as wasabi_ambulance_v2, not confirmed against v1, so fall back to the ped health
    local success, inDistress = pcall(function ()
        return wasabi_ambulance:isPlayerInDistress(playerId)
    end)
    if success == true then
        return inDistress == true
    end

    if hasWarnedIsDead == false then
        hasWarnedIsDead = true
        print("^3wasabi_ambulance does not export isPlayerInDistress, using the ped health instead...^0")
    end

    local ped = GetPlayerPed(playerId)
    if ped == 0 then
        return false
    end

    return GetEntityHealth(ped) <= 0
end

return WSB_MEDICALV1