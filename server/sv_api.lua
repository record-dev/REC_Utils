
---@type REC_Library.Server.API, REC_Library.Shared.API
local svApi, shApi = require "@REC_Library.server.sv_api", require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config

---@class REC_Utils.Server.Api
local api = {

    ---@type REC_Utils.Server.Modules.Framework
    Framework = require ("@REC_Utils.server.modules._framework." .. apiShCfg.framework),

    ---@type REC_Utils.Server.Modules.Inventory
    Inventory = require ("@REC_Utils.server.modules.inventory." .. apiShCfg.inventory),

    ---@type REC_Utils.Server.Modules.Bank
    Bank = require ("@REC_Utils.server.modules.bank." .. apiShCfg.bank),

    ---@type REC_Utils.Server.Modules.Medical
    Medical = require ("@REC_Utils.server.modules.medical." .. apiShCfg.medical),

    ---@type REC_Utils.Server.Modules.Door
    Door = require ("@REC_Utils.server.modules.door." .. apiShCfg.door),

    ---@type REC_Utils.Server.Modules.VehicleKeys
    VehicleKeys = require ("@REC_Utils.server.modules.vehiclekeys." .. apiShCfg.vehiclekeys ),

    ---@type REC_Utils.Server.Modules.Dispatch
    Dispatch = require ("@REC_Utils.server.modules.dispatch." .. apiShCfg.dispatch),

    ---@type REC_Utils.Server.Modules.Notify
    Notify = require ("@REC_Utils.server.modules.notify." .. apiShCfg.notify),

    WebHook = {

        ---@type REC_Utils.Server.Modules.WebHook.WebHook
        WebHook = require "@REC_Utils.server.modules.webhook.sv_webhook",

        ---@type REC_Utils.Server.Modules.WebHook.EmbedOptionsBuilder
        EmbedOptionsBuilder = require "@REC_Utils.server.modules.webhook.sv_embedOptionsBuilder",
    },
}

return api