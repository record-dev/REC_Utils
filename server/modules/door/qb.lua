
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local doorType = apiShCfg.door

local apiShEnums = shApi.Enums
local doorTypes = apiShEnums.DoorTypes

if doorType ~= doorTypes.qb then
    return
end

---[[
---     Read Config.DoorList through the qb-doorlock:server:setupDoors callback
---     qb-doorlock has no export for it, so the callback function is taken from qb-core ServerCallbacks
---]]
---@return table<string, table>|nil
local function fetchDoorList()
    local qbCore = exports["qb-core"]:GetCoreObject({ "ServerCallbacks" })
    local callback = qbCore.ServerCallbacks ~= nil and qbCore.ServerCallbacks["qb-doorlock:server:setupDoors"] or nil

    if callback == nil then
        print("^3qb-doorlock setupDoors callback is not founded...^0")
        return nil
    end

    ---@type table<string, table>|nil
    local doorList = nil
    callback(0, function (doors)
        doorList = doors
    end)

    return doorList
end

---[[
---     Convert a Config.DoorList entry to the ox_doorlock like shape
---     id is the string key on qb-doorlock, state is 1 when locked
---]]
---@param key string|integer
---@param data table
---@return table
local function toDoor(key, data)
    local door = {}
    for k, v in pairs(data) do
        door[k] = v
    end

    door.id = key
    door.name = data.doorLabel or tostring(key)
    door.state = data.locked == true and 1 or 0

    return door
end

---@type REC_Utils.Server.Modules.Door
---@diagnostic disable-next-line: missing-fields
local QB_DOOR = {}

function QB_DOOR:getDoor(doorId)

    local doorList = fetchDoorList()
    if doorList == nil then
        return {}
    end

    local data = doorList[doorId] or doorList[tostring(doorId)]
    if data == nil then
        print(("^3qb-doorlock door is not founded... doorId: %s^0"):format(tostring(doorId)))
        return {}
    end

    return toDoor(doorId, data)
end

-- matches the Config.DoorList key or the doorLabel
function QB_DOOR:getDoorFromName(name)

    local doorList = fetchDoorList()
    if doorList == nil then
        return {}
    end

    for key, data in pairs(doorList) do
        if key == name or data.doorLabel == name then
            return toDoor(key, data)
        end
    end

    print(("^3qb-doorlock door is not founded... name: %s^0"):format(tostring(name)))
    return {}
end

function QB_DOOR:getAllDoors()

    local doorList = fetchDoorList()
    if doorList == nil then
        return {}
    end

    local doors = {}
    for key, data in pairs(doorList) do
        doors[#doors+1] = toDoor(key, data)
    end

    return doors
end

---[[
---     state follows ox_doorlock: 1 is locked, 0 is unlocked. qb-doorlock keys doors by a string doorID
---     updateState needs a loaded QBCore player as sentSource, so one is lent (it may be logged as the operator)
---     true only means the event fired: an unknown doorId still returns true
---]]
function QB_DOOR:setDoorState(doorId, state)

    ---@type integer|nil
    local sentSource = nil
    for _, id in ipairs(GetPlayers()) do
        if exports["qb-core"]:GetPlayer(tonumber(id)) ~= nil then
            sentSource = tonumber(id)
            break
        end
    end

    if sentSource == nil then
        print("^3no loaded player to run qb-doorlock updateState...^0")
        return false
    end

    TriggerEvent("qb-doorlock:server:updateState", tostring(doorId), state == 1, false, false, true, false, false, sentSource)
    return true
end

return QB_DOOR
