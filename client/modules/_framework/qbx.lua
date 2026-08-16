
---[[
---     Support QBOX
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.qbx then
    return
end

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local QBOX = {}

-- local qbx_core = exports.qbx_core

function QBOX:setOnPlayerLoaded(onPlayerLoaded)
    AddEventHandler("QBCore:Client:OnPlayerLoaded", function (...)
        onPlayerLoaded()
    end)
end

function QBOX:setOnPlayerUnLoaded(onPlayerUnLoaded)
    RegisterNetEvent("qbx_core:client:playerLoggedOut", function ()
        onPlayerUnLoaded()
    end)
end

return QBOX
