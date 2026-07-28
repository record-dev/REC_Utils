
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclekeys = apiShCfg.vehiclekeys

local apiShEnums = shApi.Enums
local vehiclekeysTypes = apiShEnums.VehiclekeysTypes

if vehiclekeys ~= vehiclekeysTypes.wsb then
    return
end

local wsb_carlock = exports.wasabi_carlock

---@type REC_Utils.Server.Modules.VehicleKeys
---@diagnostic disable-next-line: missing-fields
local WSB_CARLOCK = {}

function WSB_CARLOCK:hasKey(playerId, vehicle)
    return wsb_carlock:HasKey(playerId, GetVehicleNumberPlateText(vehicle))
end

function WSB_CARLOCK:giveKey(playerId, vehicle, skipNotify)
    skipNotify = skipNotify or false

    wsb_carlock:GiveKey(playerId, vehicle, GetVehicleNumberPlateText(vehicle))

    return true
end

function WSB_CARLOCK:removeKey(playerId, vehicle, skipNotify)
    skipNotify = skipNotify or false

    wsb_carlock:RemoveKey(playerId, vehicle, GetVehicleNumberPlateText(vehicle))

    return true
end

return WSB_CARLOCK