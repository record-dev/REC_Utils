
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local doorType = apiShCfg.door

local apiShEnums = shApi.Enums
local doorTypes = apiShEnums.DoorTypes

if doorType ~= doorTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Door
---@diagnostic disable-next-line: missing-fields
local CUSTOM_DOOR = {}



return CUSTOM_DOOR