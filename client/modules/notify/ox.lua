
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local notify = apiShCfg.notify

local apiShEnums = shApi.Enums
local notifyTypes = apiShEnums.NotifyTypes

if notify ~= notifyTypes.ox then
    return
end

---@type REC_Utils.Client.Modules.Notify
---@diagnostic disable-next-line: missing-fields
local OX_NOTIFY = {}

function OX_NOTIFY:trigger(notifyType, title, msg, duration, playSound)
    -- ox_lib's own event, so this adapter still targets ox_lib and not the REC_Library toast
    TriggerEvent("ox_lib:notify", {
        type = notifyType,
        title = title,
        description = msg,
        duration = duration,
        sound = (function ()
            return playSound == true and {
                set = "HUD_FRONTEND_DEFAULT_SOUNDSET",
                name = "SELECT",
            } or nil
        end)(),
    })
    return true
end

return OX_NOTIFY