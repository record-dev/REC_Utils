
---[[
---     Support REC_Core
---     read from the player metadata, a missing key hides the gauge
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

local REC_Core = exports.REC_Core

---@type REC_Utils.Client.Modules.Status
---@diagnostic disable-next-line: missing-fields
local REC = {}

function REC:get(name)

    if REC_Core:isLoaded() == false then
        return nil
    end

    return tonumber(REC_Core:getMetadata(name))
end

return REC
