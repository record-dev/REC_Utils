
---@type REC_Library.Client.API, REC_Library.Shared.API
local clApi, shApi = require "@REC_Library.client.cl_api", require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config

---@class REC_Utils.Client.Api
local api = {

    ---@type REC_Utils.Client.Modules.Framework
    Framework = require ("@REC_Utils.client.modules._framework." .. apiShCfg.framework),

    Dev = {

        ---@type REC_Utils.Client.Modules.Dev.EntityPlacer
        EntityPlacer = require "@REC_Utils.client.modules.dev.entityplacer",

        ---@type REC_Utils.Client.Modules.Dev.EntityPlacerConfigBuilder
        EntityPlacerConfigBuilder = require "@REC_Utils.client.modules.dev.entityplacerConfigBuilder",
    },

    ---@type REC_Utils.Client.Modules.Inventory
    Inventory = require ("@REC_Utils.client.modules.inventory." .. apiShCfg.inventory),

    Target = {

        ---@type REC_Utils.Client.Modules.Target
        Target = require ("@REC_Utils.client.modules.target." .. apiShCfg.target),

        ---@type REC_Utils.Client.Modules.Target.TargetOptionsConfigBuilder
        OptionConfigBuilder = require "@REC_Utils.client.modules.target._configBuilder"
    },

    ---@type REC_Utils.Client.Modules.Medical
    Medical = require ("@REC_Utils.client.modules.medical." .. apiShCfg.medical),

    ---@type REC_Utils.Client.Modules.VehicleFuel
    VehicleFuel = require ("@REC_Utils.client.modules.vehiclefuel." .. apiShCfg.vehiclefuel),

    ---@type REC_Utils.Client.Modules.Notify
    Notify = require ("@REC_Utils.client.modules.notify." .. apiShCfg.notify),

    ---@type REC_Utils.Client.Modules.Raycast
    Raycast = require "@REC_Utils.client.modules.raycast",

    ---@type REC_Utils.Client.Modules.HelpText
    HelpText = require "@REC_Utils.client.modules.helptext"
}

return api