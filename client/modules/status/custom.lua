
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

---@type REC_Utils.Client.Modules.Status
---@diagnostic disable-next-line: missing-fields
local CUSTOM = {}

function CUSTOM:get(name)
    -- return the value of hunger / thirst / stress as 0 to 100 (100 is full), nil hides the gauge
    -- if name == "hunger" then
    --     return exports.xxx:getHunger()
    -- end
    return nil
end

return CUSTOM
