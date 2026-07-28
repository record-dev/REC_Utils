
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclekeys = apiShCfg.vehiclekeys

local apiShEnums = shApi.Enums
local vehiclekeysTypes = apiShEnums.VehiclekeysTypes

if vehiclekeys ~= vehiclekeysTypes.qbx then
    return
end

local qbx_vehiclekeys = exports.qbx_vehiclekeys

---@type REC_Utils.Server.Modules.VehicleKeys
---@diagnostic disable-next-line: missing-fields
local QBX_VEHICLEKEYS = {}

function QBX_VEHICLEKEYS:hasKey(playerId, vehicle)
    return qbx_vehiclekeys:HasKeys(playerId, vehicle)
end

function QBX_VEHICLEKEYS:giveKey(playerId, vehicle, skipNotify)
    skipNotify = skipNotify or false

    qbx_vehiclekeys:GiveKeys(playerId, vehicle, skipNotify)

    return true
end

function QBX_VEHICLEKEYS:removeKey(playerId, vehicle, skipNotify)
    skipNotify = skipNotify or false

    qbx_vehiclekeys:RemoveKeys(playerId, vehicle, skipNotify)

    return true
end

return QBX_VEHICLEKEYS