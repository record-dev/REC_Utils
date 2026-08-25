
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclekeys = apiShCfg.vehiclekeys

local apiShEnums = shApi.Enums
local vehiclekeysTypes = apiShEnums.VehiclekeysTypes

if vehiclekeys ~= vehiclekeysTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.VehicleKeys
---@diagnostic disable-next-line: missing-fields
local CUSTOM_VEHICLEKEYS = {}

function CUSTOM_VEHICLEKEYS:hasKey(playerId, vehicle)

    -- no keys here, so everyone always has them
    return true
end

function CUSTOM_VEHICLEKEYS:giveKey(playerId, vehicle, skipNotify)
    skipNotify = skipNotify or false

    

    return true
end

function CUSTOM_VEHICLEKEYS:removeKey(playerId, vehicle, skipNotify)
    skipNotify = skipNotify or false

    

    return true
end

return CUSTOM_VEHICLEKEYS