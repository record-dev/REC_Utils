
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local doorType = apiShCfg.door

local apiShEnums = shApi.Enums
local doorTypes = apiShEnums.DoorTypes

if doorType ~= doorTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Door
---@diagnostic disable-next-line: missing-fields
local CUSTOM_DOOR = {}

function CUSTOM_DOOR:getDoor(doorId)

    -- return custom_doorlock:getDoor(doorId)

    return {}
end

function CUSTOM_DOOR:getDoorFromName(name)

    -- return custom_doorlock:getDoorFromName(name)

    return {}
end

function CUSTOM_DOOR:getAllDoors()

    -- return custom_doorlock:getAllDoors()

    return {}
end

function CUSTOM_DOOR:setDoorState(doorId, state)

    -- custom_doorlock:setDoorState(doorId, state)

    return true
end

return CUSTOM_DOOR
