
---@class REC_Utils.Shared.Enum
local enum = {}

---@enum REC_Utils.Shared.Enum.Status
enum.status = {
    default = "default",
}

---@enum REC_Utils.Shared.Enum.PlaceEntityTypes
enum.placeentityTypes = {
    object = "object",
    ped = "ped",
    vehicle = "vehicle",
}

---@enum REC_Utils.Shared.Enum.GarageVehicleStates
enum.garageVehicleStates = {
    out = "out",
    stored = "stored",
    impounded = "impounded",
}



return enum