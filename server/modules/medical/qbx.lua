
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local medical = apiShCfg.medical

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.MedicalTypes

---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

if medical ~= medicalTypes.qbx then
    return
end

-- qbx_medical replicates its death state on the player state bag
local deathStateBag = "qbx_medical:deathState"

---@enum REC_Utils.Server.Modules.Medical.DeathStates
local deathStates = {
    alive = 1,
    lastStand = 2,
    dead = 3,
}

---[[
---     Read the replicated death state, alive when the player has none yet
---]]
---@param playerId integer
---@return REC_Utils.Server.Modules.Medical.DeathStates
local function getDeathState(playerId)

    -- exists check
    if GetPlayerName(playerId) == nil then
        return deathStates.alive
    end

    local deathState = Player(playerId).state[deathStateBag]
    if deathState == nil then
        return deathStates.alive
    end

    return deathState
end

---@type REC_Utils.Server.Modules.Medical
---@diagnostic disable-next-line: missing-fields
local QBX_MEDICAL = {}

function QBX_MEDICAL:revive(playerId)

    TriggerClientEvent("qbx_medical:client:playerRevived", playerId)

    return true
end

function QBX_MEDICAL:kill(playerId)

    TriggerClientEvent(events.client.kill, playerId)

    return true
end

function QBX_MEDICAL:isLastStand(playerId)
    return getDeathState(playerId) == deathStates.lastStand
end

function QBX_MEDICAL:isDead(playerId)
    return getDeathState(playerId) == deathStates.dead
end

return QBX_MEDICAL