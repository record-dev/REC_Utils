
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local garage = apiShCfg.garage

local apiShEnums = shApi.Enums
local garageTypes = apiShEnums.GarageTypes

if garage ~= garageTypes.qb then
    return
end

---@type REC_Utils.Shared.Enum
local shEnums = require "@REC_Utils.shared.sh_enum"
local vehicleStates = shEnums.garageVehicleStates

---@type REC_Utils.Server.Modules.Garage
---@diagnostic disable-next-line: missing-fields
local QB_GARAGE = {}

-- qb-garages keeps everything in player_vehicles and exposes no server exports, so this talks to the table directly
local oxmysql = exports.oxmysql

---@type string
local tableName = "player_vehicles"

-- qb-garages state: 0 out, 1 garaged, 2 impounded
local stateToQb = {
    [vehicleStates.out] = 0,
    [vehicleStates.stored] = 1,
    [vehicleStates.impounded] = 2,
}

local qbToState = {
    [0] = vehicleStates.out,
    [1] = vehicleStates.stored,
    [2] = vehicleStates.impounded,
}

local function qbTrim(value)
    return string.gsub(value, '^%s*(.-)%s*$', '%1')
end

---@param record table player_vehicles row
---@return REC_Utils.Server.Modules.Garage.Vehicle
local function toVehicle(record)
    return {
        id = record.id,
        citizenId = record.citizenid,
        model = record.vehicle,
        plate = record.plate,
        garage = record.garage,
        state = qbToState[record.state] or vehicleStates.out,
        properties = type(record.mods) == "string" and json.decode(record.mods) or nil,
    }
end

---@param playerId integer
---@return string|nil
local function getCitizenId(playerId)
    local player = exports["qb-core"]:GetCoreObject().Functions.GetPlayer(playerId)
    if player == nil then
        return nil
    end

    return player.PlayerData.citizenid
end

---@param length integer
---@return string
local function generatePlate(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local plate = ""

    for _ = 1, length do
        local index = math.random(1, #chars)
        plate = plate .. chars:sub(index, index)
    end

    return plate
end

-- qb-garages holds its garage list in a client shared config, nothing server side can read it
function QB_GARAGE:getGarages()
    print("^3qb-garages does not expose its garage list, returning an empty table...^0")
    return {}
end

function QB_GARAGE:getVehicles(citizenId, filter)
    filter = filter or {}

    local query = ("SELECT * FROM `%s` WHERE `citizenid` = ?"):format(tableName)
    local params = { citizenId }

    if filter.garage ~= nil then
        query = query .. " AND `garage` = ?"
        params[#params+1] = filter.garage
    end

    if filter.states ~= nil and #filter.states > 0 then
        local placeholders = {}
        for _, state in ipairs(filter.states) do
            placeholders[#placeholders+1] = "?"
            params[#params+1] = stateToQb[state]
        end
        query = query .. (" AND `state` IN (%s)"):format(table.concat(placeholders, ", "))
    end

    ---@type REC_Utils.Server.Modules.Garage.Vehicle[]
    local vehicles = {}

    for _, record in ipairs(oxmysql:query_async(query, params) or {}) do
        vehicles[#vehicles+1] = toVehicle(record)
    end

    return vehicles
end

function QB_GARAGE:getVehicle(id)
    local record = oxmysql:single_async(("SELECT * FROM `%s` WHERE `id` = ?"):format(tableName), { id })
    if record == nil then
        return nil
    end

    return toVehicle(record)
end

function QB_GARAGE:getVehicleByPlate(plate)
    local record = oxmysql:single_async(("SELECT * FROM `%s` WHERE `plate` = ?"):format(tableName), { qbTrim(plate) })
    if record == nil then
        return nil
    end

    return toVehicle(record)
end

function QB_GARAGE:isOwner(citizenId, plate)
    local vehicle = self:getVehicleByPlate(plate)
    if vehicle == nil then
        return false
    end

    return vehicle.citizenId == citizenId
end

function QB_GARAGE:addVehicle(citizenId, model, opts)
    opts = opts or {}

    local props = opts.properties or {}
    props.plate = opts.plate or props.plate

    if props.plate == nil then
        repeat
            props.plate = generatePlate(8)
        until self:getVehicleByPlate(props.plate) == nil
    end

    props.model = joaat(model)
    props.engineHealth = props.engineHealth or 1000.0
    props.bodyHealth = props.bodyHealth or 1000.0
    props.fuelLevel = props.fuelLevel or 100.0

    local query = ([[
        INSERT INTO `%s`
            (`license`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`, `state`)
        VALUES ((SELECT `license` FROM `players` WHERE `citizenid` = ?), ?, ?, ?, ?, ?, ?, ?)
    ]]):format(tableName)

    local vehicleId = oxmysql:insert_async(query, {
        citizenId,
        citizenId,
        model,
        props.model,
        json.encode(props),
        props.plate,
        opts.garage,
        opts.garage ~= nil and stateToQb[vehicleStates.stored] or stateToQb[vehicleStates.out],
    })

    if vehicleId == nil then
        print(("^1failed to create player vehicle... model: %s^0"):format(model))
        return nil
    end

    return vehicleId
end

function QB_GARAGE:removeVehicle(id)
    local affected = oxmysql:update_async(("DELETE FROM `%s` WHERE `id` = ?"):format(tableName), { id })
    return affected ~= nil and affected > 0
end

function QB_GARAGE:setOwner(id, citizenId)
    local query = ([[
        UPDATE `%s`
        SET `citizenid` = ?, `license` = (SELECT `license` FROM `players` WHERE `citizenid` = ?)
        WHERE `id` = ?
    ]]):format(tableName)

    local affected = oxmysql:update_async(query, { citizenId, citizenId, id })
    return affected ~= nil and affected > 0
end

-- the player must own the vehicle, qb-garages has no server side notion of a shared garage
function QB_GARAGE:storeVehicle(playerId, vehicle, garageName, opts)
    opts = opts or {}

    if DoesEntityExist(vehicle) == false then
        print(("^1vehicle does not exist... handle: %s^0"):format(tostring(vehicle)))
        return false
    end

    local record = self:getVehicleByPlate(GetVehicleNumberPlateText(vehicle))
    if record == nil then
        print("^3vehicle is not a player vehicle...^0")
        return false
    end

    if record.citizenId ~= getCitizenId(playerId) then
        print(("^3player %d does not own vehicle %s...^0"):format(playerId, tostring(record.id)))
        return false
    end

    local crumbs = { "`garage` = ?", "`state` = ?" }
    local params = { garageName, stateToQb[vehicleStates.stored] }

    if opts.properties ~= nil then
        crumbs[#crumbs+1] = "`mods` = ?"
        params[#params+1] = json.encode(opts.properties)
    end

    params[#params+1] = record.id

    local affected = oxmysql:update_async(("UPDATE `%s` SET %s WHERE `id` = ?"):format(tableName, table.concat(crumbs, ", ")), params)
    if affected == nil or affected == 0 then
        return false
    end

    DeleteEntity(vehicle)

    return true
end

function QB_GARAGE:impoundVehicle(vehicle, opts)
    opts = opts or {}

    if DoesEntityExist(vehicle) == false then
        print(("^1vehicle does not exist... handle: %s^0"):format(tostring(vehicle)))
        return false
    end

    local record = self:getVehicleByPlate(GetVehicleNumberPlateText(vehicle))
    if record == nil then
        print("^3vehicle is not a player vehicle, nothing to impound...^0")
        return false
    end

    local crumbs = { "`state` = ?" }
    local params = { stateToQb[vehicleStates.impounded] }

    if opts.garage ~= nil then
        crumbs[#crumbs+1] = "`garage` = ?"
        params[#params+1] = opts.garage
    end

    if opts.fee ~= nil then
        crumbs[#crumbs+1] = "`depotprice` = ?"
        params[#params+1] = opts.fee
    end

    if opts.properties ~= nil then
        crumbs[#crumbs+1] = "`mods` = ?"
        params[#params+1] = json.encode(opts.properties)
    end

    params[#params+1] = record.id

    local affected = oxmysql:update_async(("UPDATE `%s` SET %s WHERE `id` = ?"):format(tableName, table.concat(crumbs, ", ")), params)
    if affected == nil or affected == 0 then
        return false
    end

    DeleteEntity(vehicle)

    return true
end

return QB_GARAGE
