
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local garage = apiShCfg.garage

local apiShEnums = shApi.Enums
local garageTypes = apiShEnums.GarageTypes

if garage ~= garageTypes.qbx then
    return
end

---@type REC_Utils.Shared.Enum
local shEnums = require "@REC_Utils.shared.sh_enum"
local vehicleStates = shEnums.garageVehicleStates

---@type REC_Utils.Server.Modules.Garage
---@diagnostic disable-next-line: missing-fields
local QBX_GARAGE = {}

local qbx_core = exports.qbx_core
local qbx_vehicles = exports.qbx_vehicles
local qbx_garages = exports.qbx_garages

-- qbx_vehicles VehicleState: 0 out, 1 garaged, 2 impounded
local stateToQbx = {
    [vehicleStates.out] = 0,
    [vehicleStates.stored] = 1,
    [vehicleStates.impounded] = 2,
}

local qbxToState = {
    [0] = vehicleStates.out,
    [1] = vehicleStates.stored,
    [2] = vehicleStates.impounded,
}

---@param playerVehicle table qbx_vehicles PlayerVehicle
---@return REC_Utils.Server.Modules.Garage.Vehicle
local function toVehicle(playerVehicle)
    local props = playerVehicle.props or {}

    return {
        id = playerVehicle.id,
        citizenId = playerVehicle.citizenid,
        model = playerVehicle.modelName,
        plate = props.plate or "",
        garage = playerVehicle.garage,
        state = qbxToState[playerVehicle.state] or vehicleStates.out,
        properties = playerVehicle.props,
    }
end

---@param vehicle integer
---@return integer|nil
local function getVehicleId(vehicle)
    local vehicleId = Entity(vehicle).state.vehicleid
    if vehicleId ~= nil then
        return vehicleId
    end

    return qbx_vehicles:GetVehicleIdByPlate(GetVehicleNumberPlateText(vehicle))
end

---@param playerId integer
---@return string|nil
local function getCitizenId(playerId)
    local player = qbx_core:GetPlayer(playerId)
    if player == nil then
        return nil
    end

    return player.PlayerData.citizenid
end

function QBX_GARAGE:getGarages()

    ---@type table<string, REC_Utils.Server.Modules.Garage.GarageInfo>
    local garages = {}

    for key, config in pairs(qbx_garages:GetGarages() or {}) do
        local accessPoint = config.accessPoints ~= nil and config.accessPoints[1] or nil

        garages[key] = {
            key = key,
            label = config.label,
            type = (function ()
                if config.type == "depot" then
                    return "impound"
                end
                if config.shared == true then
                    return "shared"
                end
                return "personal"
            end)(),
            coords = accessPoint ~= nil and vector3(accessPoint.coords.x, accessPoint.coords.y, accessPoint.coords.z) or nil,
        }
    end

    return garages
end

function QBX_GARAGE:getVehicles(citizenId, filter)
    filter = filter or {}

    ---@type integer[]|nil
    local states = nil
    if filter.states ~= nil then
        states = {}
        for _, state in ipairs(filter.states) do
            states[#states+1] = stateToQbx[state]
        end
    end

    ---@type REC_Utils.Server.Modules.Garage.Vehicle[]
    local vehicles = {}

    for _, playerVehicle in ipairs(qbx_vehicles:GetPlayerVehicles({
        citizenid = citizenId,
        garage = filter.garage,
        states = states,
    }) or {}) do
        vehicles[#vehicles+1] = toVehicle(playerVehicle)
    end

    return vehicles
end

function QBX_GARAGE:getVehicle(id)
    local playerVehicle = qbx_vehicles:GetPlayerVehicle(id)
    if playerVehicle == nil then
        return nil
    end

    return toVehicle(playerVehicle)
end

function QBX_GARAGE:getVehicleByPlate(plate)
    local vehicleId = qbx_vehicles:GetVehicleIdByPlate(plate)
    if vehicleId == nil then
        return nil
    end

    return self:getVehicle(vehicleId)
end

function QBX_GARAGE:isOwner(citizenId, plate)
    local vehicle = self:getVehicleByPlate(plate)
    if vehicle == nil then
        return false
    end

    return vehicle.citizenId == citizenId
end

function QBX_GARAGE:addVehicle(citizenId, model, opts)
    opts = opts or {}

    local props = opts.properties or {}
    if opts.plate ~= nil then
        props.plate = opts.plate
    end

    local vehicleId, err = qbx_vehicles:CreatePlayerVehicle({
        model = model,
        citizenid = citizenId,
        garage = opts.garage,
        props = props,
    })

    if vehicleId == nil then
        print(("^1failed to create player vehicle... model: %s, reason: %s^0"):format(model, err ~= nil and err.message or "unknown"))
        return nil
    end

    return vehicleId
end

function QBX_GARAGE:removeVehicle(id)
    return qbx_vehicles:DeletePlayerVehicles("vehicleId", id) == true
end

function QBX_GARAGE:setOwner(id, citizenId)
    return qbx_vehicles:SetPlayerVehicleOwner(id, citizenId) == true
end

function QBX_GARAGE:storeVehicle(playerId, vehicle, garageName, opts)
    opts = opts or {}

    if DoesEntityExist(vehicle) == false then
        print(("^1vehicle does not exist... handle: %s^0"):format(tostring(vehicle)))
        return false
    end

    local vehicleId = getVehicleId(vehicle)
    if vehicleId == nil then
        print("^3vehicle is not a player vehicle...^0")
        return false
    end

    -- a shared garage takes anyone's vehicle, a personal one only the player's own
    local garageConfig = qbx_garages:GetGarages()[garageName]
    if garageConfig == nil then
        print(("^1garage is not founded... name: %s^0"):format(garageName))
        return false
    end

    if garageConfig.shared ~= true then
        local playerVehicle = qbx_vehicles:GetPlayerVehicle(vehicleId)
        if playerVehicle == nil or playerVehicle.citizenid ~= getCitizenId(playerId) then
            print(("^3player %d does not own vehicle %d...^0"):format(playerId, vehicleId))
            return false
        end
    end

    local success = qbx_vehicles:SaveVehicle(vehicle, {
        garage = garageName,
        state = stateToQbx[vehicleStates.stored],
        props = opts.properties,
    })

    if success ~= true then
        return false
    end

    qbx_core:DeleteVehicle(vehicle)

    return true
end

function QBX_GARAGE:impoundVehicle(vehicle, opts)
    opts = opts or {}

    if DoesEntityExist(vehicle) == false then
        print(("^1vehicle does not exist... handle: %s^0"):format(tostring(vehicle)))
        return false
    end

    local success = qbx_vehicles:SaveVehicle(vehicle, {
        garage = opts.garage,
        state = stateToQbx[vehicleStates.impounded],
        depotPrice = opts.fee,
        props = opts.properties,
    })

    if success ~= true then
        print("^3vehicle is not a player vehicle, nothing to impound...^0")
        return false
    end

    qbx_core:DeleteVehicle(vehicle)

    return true
end

return QBX_GARAGE
