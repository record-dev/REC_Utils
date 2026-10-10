
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

---[[
---     qb-ambulancejob mirrors the client state into the player metadata
---]]
---@param playerId integer
---@param key "isdead" | "inlaststand"
---@return boolean
local function getMetaFlag(playerId, key)

    -- exists check
    if GetPlayerName(playerId) == nil then
        return false
    end

    local player = exports["qb-core"]:GetPlayer(playerId)
    if player == nil then
        return false
    end

    local metadata = player.PlayerData?.metadata
    if metadata == nil then
        return false
    end

    return metadata[key] == true
end

function QB_MEDICAL:revive(playerId)

    -- exists check
    if GetPlayerName(playerId) == nil then
        print(("^3player is not founded... playerId: %s^0"):format(tostring(playerId)))
        return false
    end

    TriggerClientEvent("hospital:client:Revive", playerId)

    return true
end

function QB_MEDICAL:kill(playerId)

    TriggerClientEvent(events.client.kill, playerId)

    return true
end

function QB_MEDICAL:isLastStand(playerId)
    return getMetaFlag(playerId, "inlaststand")
end

function QB_MEDICAL:isDead(playerId)
    return getMetaFlag(playerId, "isdead")
end

return QB_MEDICAL