
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local vehiclefuel = apiShCfg.vehiclefuel

local apiShEnums = shApi.Enums
local vehiclefuelTypes = apiShEnums.VehiclefuelTypes

if vehiclefuel ~= vehiclefuelTypes.qb then
    return
end

---[[
--- qb-fuel and LegacyFuel share the GetFuel / SetFuel exports, so use whichever is running
---]]
---@return string
local function getResourceName()
    if GetResourceState("qb-fuel") == "started" then
        return "qb-fuel"
    end

    return "LegacyFuel"
end

---@type REC_Utils.Client.Modules.VehicleFuel
---@diagnostic disable-next-line: missing-fields
local QB_FUEL = {}

function QB_FUEL:getFuel(vehicle)
    return exports[getResourceName()]:GetFuel(vehicle)
end

function QB_FUEL:setFuel(vehicle, fuel)

    if DoesEntityExist(vehicle) == false then
        return false
    end

    fuel = math.min(math.max(fuel + 0.0, 0.0), 100.0)

    exports[getResourceName()]:SetFuel(vehicle, fuel)

    return true
end

return QB_FUEL
