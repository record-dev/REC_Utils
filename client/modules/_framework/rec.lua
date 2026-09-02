
---[[
---     Support REC_Core
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.rec then
    return
end

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local REC = {}

function REC:setOnPlayerLoaded(onPlayerLoaded)
    AddEventHandler("REC_Core:client:onPlayerLoaded", function (...)
        onPlayerLoaded()
    end)
end

function REC:setOnPlayerUnLoaded(onPlayerUnLoaded)
    AddEventHandler("REC_Core:client:onPlayerUnloaded", function (...)
        onPlayerUnLoaded()
    end)
end

return REC
