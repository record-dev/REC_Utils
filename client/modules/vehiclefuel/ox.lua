
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclefuel = apiShCfg.vehiclefuel

local apiShEnums = shApi.Enums
local vehiclefuelTypes = apiShEnums.VehiclefuelTypes

if vehiclefuel ~= vehiclefuelTypes.ox then
    return
end

---@class OxFuel.Cient.Fuel
---@field setFuel fun(self: OxFuel.Cient.Fuel, vehicle: integer, fuel: integer, )
local ox_fuel = require "@ox_fuel.client.fuel"

---@type REC_Utils.Client.Modules.VehicleFuel
---@diagnostic disable-next-line: missing-fields
local OX_FUEL = {}

function OX_FUEL:getFuel(vehicle)
    local vehState = Entity(vehicle).state
    return vehState.fuel or GetVehicleFuelLevel(vehicle)
end

function OX_FUEL:setFuel(vehicle, fuel)
    local vehState = Entity(vehicle).state
    ox_fuel:setFuel(vehicle, fuel)
    return true
end

return OX_FUEL