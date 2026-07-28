
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local dispatch = apiShCfg.dispatch

local apiShEnums = shApi.Enums
local dispatchTypes = apiShEnums.DispatchTypes

if dispatch ~= dispatchTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Dispatch
---@diagnostic disable-next-line: missing-fields
local CUSTOM_DISPATCH = {}

function CUSTOM_DISPATCH:call(config)

    local payload = {}

    --  TriggerEvent(..., payload)

    return true
end

return CUSTOM_DISPATCH