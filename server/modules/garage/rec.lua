
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local garage = apiShCfg.garage

local apiShEnums = shApi.Enums
local garageTypes = apiShEnums.GarageTypes

if garage ~= garageTypes.rec then
    return
end

---@type REC_Utils.Shared.Enum
local shEnums = require "@REC_Utils.shared.sh_enum"
local vehicleStates = shEnums.garageVehicleStates

---@type REC_Utils.Server.Modules.Garage
---@diagnostic disable-next-line: missing-fields
local REC_GARAGE = {}

local rec_garage = exports.REC_Garage

---@param row table REC_Garage.Server.Manager.ServerManagerConfigBuilder.VehicleRow
---@return REC_Utils.Server.Modules.Garage.Vehicle
local function toVehicle(row)
    return {
        id = row.uid,
        citizenId = row.ownerType == "citizen" and row.ownerId or nil,
        model = row.model,
        plate = row.plate,
        garage = row.garageKey,
        state = row.state == "impounded" and vehicleStates.impounded or vehicleStates.stored,
        properties = row.properties,
    }
end

function REC_GARAGE:getGarages()

    ---@type table<string, REC_Utils.Server.Modules.Garage.GarageInfo>
    local garages = {}

    for key, info in pairs(rec_garage:getGarages() or {}) do
        garages[key] = {
            key = key,
            label = info.label,
            type = info.type,
            coords = info.coords,
        }
    end

    return garages
end

-- REC_Garage only tracks vehicles sitting in a garage, a vehicle out in the world is never listed
function REC_GARAGE:getVehicles(citizenId, filter)
    filter = filter or {}

    ---@type table<string, true>|nil
    local wantedStates = nil
    if filter.states ~= nil then
        wantedStates = {}
        for _, state in ipairs(filter.states) do
            wantedStates[state] = true
        end
    end

    ---@type REC_Utils.Server.Modules.Garage.Vehicle[]
    local vehicles = {}

    for _, row in ipairs(rec_garage:getVehicles(citizenId, "citizen") or {}) do
        local vehicle = toVehicle(row)

        if filter.garage ~= nil and vehicle.garage ~= filter.garage then
            goto continue
        end

        if wantedStates ~= nil and wantedStates[vehicle.state] == nil then
            goto continue
        end

        vehicles[#vehicles+1] = vehicle

        ::continue::
    end

    return vehicles
end

function REC_GARAGE:getVehicle(id)
    local row = rec_garage:getVehicle(id)
    if row == nil then
        return nil
    end

    return toVehicle(row)
end

function REC_GARAGE:getVehicleByPlate(plate)
    local row = rec_garage:getVehicleByPlate(plate)
    if row == nil then
        return nil
    end

    return toVehicle(row)
end

function REC_GARAGE:isOwner(citizenId, plate)
    local vehicle = self:getVehicleByPlate(plate)
    if vehicle == nil then
        return false
    end

    return vehicle.citizenId == citizenId
end

function REC_GARAGE:addVehicle(citizenId, model, opts)
    opts = opts or {}

    return rec_garage:addVehicle("citizen", citizenId, model, {
        garageKey = opts.garage,
        plate = opts.plate,
        vehType = opts.vehType,
        label = opts.label,
        properties = opts.properties,
    })
end

function REC_GARAGE:removeVehicle(id)
    return rec_garage:removeVehicle(id) == true
end

function REC_GARAGE:setOwner(id, citizenId)
    return rec_garage:setVehicleOwner(id, "citizen", citizenId) == true
end

function REC_GARAGE:storeVehicle(playerId, vehicle, garageKey, opts)
    opts = opts or {}

    if type(opts.model) ~= "string" or opts.model == "" then
        print("^1REC_Garage cannot store a vehicle without opts.model^0")
        return false
    end

    if DoesEntityExist(vehicle) == false then
        print(("^1vehicle does not exist... handle: %s^0"):format(tostring(vehicle)))
        return false
    end

    local uid = rec_garage:storeVehicle(playerId, NetworkGetNetworkIdFromEntity(vehicle), garageKey, {
        model = opts.model,
        vehType = opts.vehType,
        properties = opts.properties,
    })

    return uid ~= nil
end

function REC_GARAGE:impoundVehicle(vehicle, opts)
    opts = opts or {}

    if type(opts.model) ~= "string" or opts.model == "" then
        print("^1REC_Garage cannot impound a vehicle without opts.model^0")
        return false
    end

    if DoesEntityExist(vehicle) == false then
        print(("^1vehicle does not exist... handle: %s^0"):format(tostring(vehicle)))
        return false
    end

    local uid = rec_garage:impoundVehicle(NetworkGetNetworkIdFromEntity(vehicle), {
        model = opts.model,
        garageKey = opts.garage,
        reason = opts.reason,
        fee = opts.fee,
        ownerCitizenId = opts.ownerCitizenId,
    })

    return uid ~= nil
end

return REC_GARAGE
