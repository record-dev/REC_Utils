
---[[
---     Support QBCORE
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.qb then
    return
end

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local QB = {}

function QB:doesRequiredJobsExist()

end

function QB:setOnPlayerLoaded(onPlayerLoaded)
    RegisterNetEvent("QBCore:Server:OnPlayerLoaded", function (...)
        local src = source
        onPlayerLoaded(src)
    end)
end

function QB:setOnPlayerUnLoaded(onPlayerUnLoaded)
    ---@param src integer
    AddEventHandler("QBCore:Server:OnPlayerUnload", function (src)
        onPlayerUnLoaded(src)
    end)
end

return QB