
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local dispatch = apiShCfg.dispatch

local apiShEnums = shApi.Enums
local dispatchTypes = apiShEnums.DispatchTypes

if dispatch ~= dispatchTypes.rec then
    return
end

---@type REC_Utils.Server.Modules.Dispatch
---@diagnostic disable-next-line: missing-fields
local REC_DISPATCH = {}

function REC_DISPATCH:call(config)

    if GetResourceState("REC_Dispatch") ~= "started" then
        return false
    end

    local id = exports.REC_Dispatch:createAlert({
        code = config.code,
        codeName = config.codeName,
        title = config.title,
        message = config.msg,
        description = config.description,
        coords = config.coords,
        radius = config.radius,
        duration = config.duration,
        jobs = config.jobs,
        priority = config.priority,
        blip = {
            label = config.spriteLabel,
            sprite = config.sprite,
            color = config.spriteColor,
            scale = config.spriteScale,
        },
        sound = config.soundName ~= nil and { name = config.soundName, set = config.soundDict, } or nil,
        icon = config.icon,
        iconColor = config.iconColor,
    })

    return id ~= nil
end

return REC_DISPATCH
