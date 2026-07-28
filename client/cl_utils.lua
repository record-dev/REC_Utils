
---@type REC_Utils.Server.Config
local shCfg = require "@REC_Utils.config.sh_config"

---@class REC_Utils.Client.Utils
local utils = {}



---[[
---     Debug output
---]]
---@param context string
function utils:debugPrint(context, ...)
    if shCfg.debugMode == true then
        print(context, ...)
    end
end

return utils