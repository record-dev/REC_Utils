
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local notify = apiShCfg.notify

local apiShEnums = shApi.Enums
local notifyTypes = apiShEnums.NotifyTypes

if notify ~= notifyTypes.okok then
    return
end

local okokNotify = exports.okokNotify

---@type REC_Utils.Client.Modules.Notify
---@diagnostic disable-next-line: missing-fields
local OKOK_NOTIFY = {}

function OKOK_NOTIFY:trigger(notifyType, title, msg, duration, playSound)
    okokNotify:Alert(title, msg, duration, notifyType, playSound)
    return true
end

return OKOK_NOTIFY