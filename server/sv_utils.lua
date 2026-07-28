
---@type REC_Library.Server.API, REC_Library.Shared.API
local svApi, shApi = require "@REC_Library.server.sv_api", require "@REC_Library.shared.sh_api"

---@type REC_Utils.Shared.Config, REC_Utils.Server.Config
local shCfg, svCfg = require "@REC_Utils.config.sh_config", require "@REC_Utils.config.sv_config"

---@class REC_Utils.Server.Utils
local utils = {}


---[[
---     Debug output
---]]
function utils:debugPrint(...)
    if svCfg.debugMode == true then
        print(...)
    end
end

return utils