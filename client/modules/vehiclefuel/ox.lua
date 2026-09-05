
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclefuel = apiShCfg.vehiclefuel

local apiShEnums = shApi.Enums
local vehiclefuelTypes = apiShEnums.VehiclefuelTypes

if vehiclefuel ~= vehiclefuelTypes.ox then
    return
end

---@type REC_Utils.Client.Modules.VehicleFuel
---@diagnostic disable-next-line: missing-fields
local OX_FUEL = {}

function OX_FUEL:getFuel(vehicle)
    local vehState = Entity(vehicle).state
    return vehState.fuel or GetVehicleFuelLevel(vehicle)
end

-- ox_fuel reads the fuel state bag, so writing it is enough and its client module never has to load here
function OX_FUEL:setFuel(vehicle, fuel)

    if DoesEntityExist(vehicle) == false then
        return false
    end

    fuel = math.min(math.max(fuel + 0.0, 0.0), 100.0)

    SetVehicleFuelLevel(vehicle, fuel)
    Entity(vehicle).state:set("fuel", fuel, true)

    return true
end

return OX_FUEL