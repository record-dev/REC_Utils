
---[[
---     Support OX_CORE
---     ox statuses grow towards 100 as the need builds up, so hunger / thirst are flipped to "how full"
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

-- the ox_core lib defines the global Ox
local loaded = pcall(require, "@ox_core.lib.init")
if loaded == false then
    print("^3failed to load @ox_core/lib/init.lua, statuses are unavailable...^0")
end

---@type REC_Utils.Client.Modules.Status
---@diagnostic disable-next-line: missing-fields
local OX = {}

---@type table<string, true>
local inverted = {
    hunger = true,
    thirst = true,
}

function OX:get(name)

    if loaded == false or Ox == nil then
        return nil
    end

    local player = Ox.GetPlayer()
    if player == nil or player.getStatus == nil then
        return nil
    end

    local value = tonumber(player.getStatus(name))
    if value == nil then
        return nil
    end

    if inverted[name] == true then
        return 100 - value
    end

    return value
end

return OX
