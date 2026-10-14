
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local nametag = apiShCfg.nametag

local apiShEnums = shApi.Enums
local nametagTypes = apiShEnums.NameTagTypes

if nametag ~= nametagTypes.rec then
    return
end

---@type REC_Utils.Server.Modules.NameTag
---@diagnostic disable-next-line: missing-fields
local REC_NAMETAG = {}

function REC_NAMETAG:setTitle(playerId, title)
    return exports.REC_NameTag:setTitle(playerId, title) == true
end

function REC_NAMETAG:getTitle(playerId)
    return exports.REC_NameTag:getTitle(playerId)
end

function REC_NAMETAG:getIsVisible(playerId)
    return exports.REC_NameTag:getIsVisible(playerId) == true
end

function REC_NAMETAG:setVisible(playerId, visible)
    return exports.REC_NameTag:setVisible(playerId, visible) == true
end

function REC_NAMETAG:getNameTag(playerId)
    return exports.REC_NameTag:getNameTag(playerId)
end

return REC_NAMETAG
