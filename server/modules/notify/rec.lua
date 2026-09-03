
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local notify = apiShCfg.notify

local apiShEnums = shApi.Enums
local notifyTypes = apiShEnums.NotifyTypes

if notify ~= notifyTypes.rec then
    return
end

local recNotify = exports.REC_Hud

---@type REC_Utils.Server.Modules.Notify
---@diagnostic disable-next-line: missing-fields
local REC_NOTIFY = {}

function REC_NOTIFY:trigger(playerId, notifyType, title, msg, duration, playSound)
    recNotify:notify(playerId, {
        type = notifyType,
        title = title,
        description = msg,
        duration = duration,
        playSound = playSound,
    })
    return true
end

return REC_NOTIFY
