
---[[
---     Support ESX
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.esx then
    return
end

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local ESX = {}

function ESX:setOnPlayerLoaded(onPlayerLoaded)
    RegisterNetEvent("esx:playerLoaded", function (...)
        onPlayerLoaded()
    end)
end

function ESX:setOnPlayerUnLoaded(onPlayerUnLoaded)
    RegisterNetEvent("esx:onPlayerLogout", function (...)
        onPlayerUnLoaded()
    end)
end

return ESX
