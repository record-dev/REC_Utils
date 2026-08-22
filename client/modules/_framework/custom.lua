
---[[
---     Support CUSTOM
---     framework が検出されなかったときの落とし先。利用者が自分のフレームワークに合わせて中身を書く
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

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local CUSTOM = {}

function CUSTOM:setOnPlayerLoaded(onPlayerLoaded)
    -- 自分のフレームワークのロードイベントに差し替える
    -- RegisterNetEvent("xxx:playerLoaded", function (...)
    --     onPlayerLoaded()
    -- end)
end

function CUSTOM:setOnPlayerUnLoaded(onPlayerUnLoaded)
    -- 自分のフレームワークのアンロードイベントに差し替える
    -- RegisterNetEvent("xxx:playerLogout", function (...)
    --     onPlayerUnLoaded()
    -- end)
end

return CUSTOM
