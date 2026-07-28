
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local dispatch = apiShCfg.dispatch

local apiShEnums = shApi.Enums
local dispatchTypes = apiShEnums.DispatchTypes

if dispatch ~= dispatchTypes.lb then
    return
end

---@type REC_Utils.Server.Modules.Dispatch
---@diagnostic disable-next-line: missing-fields
local DISPATCH_LB_TABLET = {}

function DISPATCH_LB_TABLET:call(config)

    local payload = {
        title = config.title,
        description = config.description,
        priority = config.priority,
        code = config.code,
        time = config.duration,
        job = config.jobs,
        location = {
            label = config.spriteLabel,
            coords = { x = config.coords.x, y = config.coords.y, },
        },
        blip = {
            label = config.spriteLabel,
            sprite = config.sprite,
            color = config.spriteColor,
            size = config.spriteScale,
        },
    }

    exports["lb-tablet"]:AddDispatch(payload)

    return true
end

return DISPATCH_LB_TABLET