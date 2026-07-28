
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclefuel = apiShCfg.vehiclefuel

local apiShEnums = shApi.Enums
local vehiclefuelTypes = apiShEnums.VehiclefuelTypes

if vehiclefuel ~= vehiclefuelTypes.custom then
    return
end

-- local custom_fuel = exports["cdn-fuel"]

---@type REC_Utils.Client.Modules.VehicleFuel
---@diagnostic disable-next-line: missing-fields
local CUSTOM_FUEL = {}

function CUSTOM_FUEL:getFuel(vehicle)
    -- return custom_fuel:GetFuel(vehicle)
end

function CUSTOM_FUEL:setFuel(vehicle, fuel)
    -- return custom_fuel:SetFuel(vehicle, fuel)
end

return CUSTOM_FUEL