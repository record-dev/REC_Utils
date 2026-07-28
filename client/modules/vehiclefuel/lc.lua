
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclefuel = apiShCfg.vehiclefuel

local apiShEnums = shApi.Enums
local vehiclefuelTypes = apiShEnums.VehiclefuelTypes

if vehiclefuel ~= vehiclefuelTypes.lc then
    return
end

local lc_fuel = exports.lc_fuel

---@type REC_Utils.Client.Modules.VehicleFuel
---@diagnostic disable-next-line: missing-fields
local LC_FUEL = {}

function LC_FUEL:getFuel(vehicle)
    return lc_fuel:GetFuel(vehicle)
end

function LC_FUEL:setFuel(vehicle, fuel)
    return lc_fuel:SetFuel(vehicle, fuel)
end

return LC_FUEL