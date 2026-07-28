

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

---@type REC_Utils.Server.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local ESX = {}



return ESX
