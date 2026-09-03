
---[[
---     Support ESX
---     esx_status keeps the values (0 to 1000000), the percent is what the HUD wants
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

---@type REC_Utils.Client.Modules.Status
---@diagnostic disable-next-line: missing-fields
local ESX = {}

---@type table<string, number>
local cached = {}

-- esx_status sends every status on its own tick
RegisterNetEvent("esx_status:onTick", function (statuses)

    if type(statuses) ~= "table" then
        return
    end

    for _, status in ipairs(statuses) do
        if type(status.name) == "string" then
            cached[status.name] = tonumber(status.percent)
        end
    end
end)

RegisterNetEvent("esx:onPlayerLogout", function ()
    cached = {}
end)

function ESX:get(name)

    if cached[name] ~= nil then
        return cached[name]
    end

    -- the callback runs synchronously inside esx_status
    local percent = nil

    TriggerEvent("esx_status:getStatus", name, function (status)
        if status ~= nil then
            percent = status.getPercent()
        end
    end)

    return tonumber(percent)
end

return ESX
