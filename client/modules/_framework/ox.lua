
---[[
---     Support OX_CORE
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.ox then
    return
end

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local OX = {}

function OX:setOnPlayerLoaded(onPlayerLoaded)
    RegisterNetEvent("ox:playerLoaded", function (...)
        onPlayerLoaded()
    end)
end

function OX:setOnPlayerUnLoaded(onPlayerUnLoaded)
    RegisterNetEvent("ox:playerLogout", function (...)
        onPlayerUnLoaded()
    end)
end

return OX
