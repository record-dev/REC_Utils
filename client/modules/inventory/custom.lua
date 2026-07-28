
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local inventory = apiShCfg.inventory

local apiShEnums = shApi.Enums
local invTypes = apiShEnums.InventoryTypes

if inventory ~= invTypes.custom then
    return
end

---@type REC_Utils.Client.Modules.Inventory
---@diagnostic disable-next-line: missing-fields
local CUSTOM_INVENTORY = {}

function CUSTOM_INVENTORY:items(name)
    return 
end

function CUSTOM_INVENTORY:getItemCount(item)
    return 
end

return CUSTOM_INVENTORY