
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local notify = apiShCfg.notify

local apiShEnums = shApi.Enums
local notifyTypes = apiShEnums.NotifyTypes

if notify ~= notifyTypes.okok then
    return
end

---@type REC_Utils.Server.Modules.Notify
---@diagnostic disable-next-line: missing-fields
local OKOK_NOTIFY = {}

function OKOK_NOTIFY:trigger(playerId, notifyType, title, msg, duration, playSound, sound)
    TriggerClientEvent('okokNotify:Alert', playerId, title, msg, duration, notifyType, playSound)
    return true
end

return OKOK_NOTIFY