
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local dispatch = apiShCfg.dispatch

local apiShEnums = shApi.Enums
local dispatchTypes = apiShEnums.DispatchTypes

if dispatch ~= dispatchTypes.ps then
    return
end

---@type REC_Utils.Server.Modules.Dispatch
---@diagnostic disable-next-line: missing-fields
local DISPATCH_PS_DISPATCH = {}

function DISPATCH_PS_DISPATCH:call(config)

    local payload = {
        message = config.msg,
        description = config.description,
        coords = config.coords,
        origin = config.coords,
        jobs = config.jobs,
        code = config.code,
        codeName = "NONE",
        displayCode = config.code,
        icon = config.icon,
        priority = config.priority == "high" and 1 or config.priority == "medium" and 2 or 3,
        alert = {
            text = config.spriteLabel,
            jobs = config.jobs,
            description = config.description,
            displayCode = config.code,
            sprite = config.sprite,
            color = config.spriteColor,
            scale = config.spriteScale,
        },
    }

     TriggerEvent("ps-dispatch:server:notify", payload)

    return true
end

return DISPATCH_PS_DISPATCH