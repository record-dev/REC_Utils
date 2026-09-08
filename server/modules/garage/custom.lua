
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local garage = apiShCfg.garage

local apiShEnums = shApi.Enums
local garageTypes = apiShEnums.GarageTypes

if garage ~= garageTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Garage
---@diagnostic disable-next-line: missing-fields
local CUSTOM_GARAGE = {}

-- no garage resource installed, nothing is owned and nothing can be parked

function CUSTOM_GARAGE:getGarages()
    return {}
end

function CUSTOM_GARAGE:getVehicles(citizenId, filter)
    return {}
end

function CUSTOM_GARAGE:getVehicle(id)
    return nil
end

function CUSTOM_GARAGE:getVehicleByPlate(plate)
    return nil
end

function CUSTOM_GARAGE:isOwner(citizenId, plate)
    return false
end

function CUSTOM_GARAGE:addVehicle(citizenId, model, opts)
    return nil
end

function CUSTOM_GARAGE:removeVehicle(id)
    return false
end

function CUSTOM_GARAGE:setOwner(id, citizenId)
    return false
end

function CUSTOM_GARAGE:storeVehicle(playerId, vehicle, garageName, opts)
    return false
end

function CUSTOM_GARAGE:impoundVehicle(vehicle, opts)
    return false
end

return CUSTOM_GARAGE
