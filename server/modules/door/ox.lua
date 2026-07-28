
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local doorType = apiShCfg.door

local apiShEnums = shApi.Enums
local doorTypes = apiShEnums.DoorTypes

if doorType ~= doorTypes.ox then
    return
end

local ox_doorlock = exports.ox_doorlock

---@type REC_Utils.Server.Modules.Door
---@diagnostic disable-next-line: missing-fields
local OX_DOOR = {}

function OX_DOOR:getDoor(doorId)
    return ox_doorlock:getDoor(doorId)
end

function OX_DOOR:getDoorFromName(name)
    return ox_doorlock:getDoorFromName(name)
end

function OX_DOOR:getAllDoors()
    return ox_doorlock:getAllDoors()
end

function OX_DOOR:setDoorState(doorId, state)
    ox_doorlock:setDoorState(doorId, state)
    return true
end

return OX_DOOR