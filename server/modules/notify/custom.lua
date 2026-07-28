
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local notify = apiShCfg.notify

local apiShEnums = shApi.Enums
local notifyTypes = apiShEnums.NotifyTypes

if notify ~= notifyTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Notify
---@diagnostic disable-next-line: missing-fields
local CUSTOM_NOTIFY = {}

function CUSTOM_NOTIFY:trigger(playerId, notifyType, title, msg, duration, playSound)
    -- TriggerClientEvent(..., {})
    return true
end

return CUSTOM_NOTIFY