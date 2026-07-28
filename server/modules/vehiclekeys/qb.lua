
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclekeys = apiShCfg.vehiclekeys

local apiShEnums = shApi.Enums
local vehiclekeysTypes = apiShEnums.VehiclekeysTypes

if vehiclekeys ~= vehiclekeysTypes.qb then
    return
end

local function qbTrim(value)
    return string.gsub(value, '^%s*(.-)%s*$', '%1')
end

---@type REC_Utils.Server.Modules.VehicleKeys
---@diagnostic disable-next-line: missing-fields
local QB_VEHICLEKEYS = {}

local qb_vehiclekeys = exports["qb-vehiclekeys"]

function QB_VEHICLEKEYS:hasKey(playerId, vehicle)
    local plate = qbTrim(GetVehicleNumberPlateText(vehicle))
    return qb_vehiclekeys:HasKeys(playerId, plate)
end

function QB_VEHICLEKEYS:giveKey(playerId, vehicle, skipNotify)
    skipNotify = skipNotify or false

    local plate = qbTrim(GetVehicleNumberPlateText(vehicle))
    qb_vehiclekeys:GiveKeys(playerId, plate)

    return true
end

function QB_VEHICLEKEYS:removeKey(playerId, vehicle, skipNotify)
    skipNotify = skipNotify or false

    local plate = qbTrim(GetVehicleNumberPlateText(vehicle))
    qb_vehiclekeys:RemoveKeys(playerId, plate)

    return true
end

return QB_VEHICLEKEYS