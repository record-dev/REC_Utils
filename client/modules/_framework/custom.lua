
---[[
---     Support CUSTOM
---     fallback when no framework is detected, fill it in for your own framework
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.custom then
    return
end

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local CUSTOM = {}

function CUSTOM:setOnPlayerLoaded(onPlayerLoaded)
    -- replace this with your framework's load event
    -- RegisterNetEvent("xxx:playerLoaded", function (...)
    --     onPlayerLoaded()
    -- end)
end

function CUSTOM:setOnPlayerUnLoaded(onPlayerUnLoaded)
    -- replace this with your framework's unload event
    -- RegisterNetEvent("xxx:playerLogout", function (...)
    --     onPlayerUnLoaded()
    -- end)
end

return CUSTOM
