
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclefuel = apiShCfg.vehiclefuel

local apiShEnums = shApi.Enums
local vehiclefuelTypes = apiShEnums.VehiclefuelTypes

if vehiclefuel ~= vehiclefuelTypes.cdn then
    return
end

local cdn_fuel = exports["cdn-fuel"]

---@type REC_Utils.Client.Modules.VehicleFuel
---@diagnostic disable-next-line: missing-fields
local CDN_FUEL = {}

function CDN_FUEL:getFuel(vehicle)
    return cdn_fuel:GetFuel(vehicle)
end

function CDN_FUEL:setFuel(vehicle, fuel)
    return cdn_fuel:SetFuel(vehicle, fuel)
end

return CDN_FUEL