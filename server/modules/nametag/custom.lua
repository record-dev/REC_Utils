
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local nametag = apiShCfg.nametag

local apiShEnums = shApi.Enums
local nametagTypes = apiShEnums.NameTagTypes

if nametag ~= nametagTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.NameTag
---@diagnostic disable-next-line: missing-fields
local CUSTOM_NAMETAG = {}

-- no nametag resource installed, there is no tag to read or change

function CUSTOM_NAMETAG:setTitle(playerId, title)
    return false
end

function CUSTOM_NAMETAG:getTitle(playerId)
    return nil
end

function CUSTOM_NAMETAG:getIsVisible(playerId)
    return false
end

function CUSTOM_NAMETAG:setVisible(playerId, visible)
    return false
end

function CUSTOM_NAMETAG:getNameTag(playerId)
    return nil
end

return CUSTOM_NAMETAG
