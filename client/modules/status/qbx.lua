
---[[
---     Support QBOX
---     hunger / thirst / stress live in PlayerData.metadata (0 to 100, 100 is full)
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

local qbx_core = exports.qbx_core

---@type REC_Utils.Client.Modules.Status
---@diagnostic disable-next-line: missing-fields
local QBOX = {}

---@type table<string, number>
local cached = {}

-- qbx_core keeps the qb hud events
RegisterNetEvent("hud:client:UpdateNeeds", function (hunger, thirst)
    cached.hunger, cached.thirst = tonumber(hunger), tonumber(thirst)
end)

RegisterNetEvent("hud:client:UpdateStress", function (stress)
    cached.stress = tonumber(stress)
end)

RegisterNetEvent("qbx_core:client:playerLoggedOut", function ()
    cached = {}
end)

function QBOX:get(name)

    if cached[name] ~= nil then
        return cached[name]
    end

    local playerData = qbx_core:GetPlayerData()
    if playerData == nil or playerData.metadata == nil then
        return nil
    end

    return tonumber(playerData.metadata[name])
end

return QBOX
