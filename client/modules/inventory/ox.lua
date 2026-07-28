
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local inventory = apiShCfg.inventory

local apiShEnums = shApi.Enums
local invTypes = apiShEnums.InventoryTypes

if inventory ~= invTypes.ox then
    return
end

---@type REC_Utils.Client.Modules.Inventory
---@diagnostic disable-next-line: missing-fields
local OX_INVENTORY = {}

local ox_inventory = exports.ox_inventory

function OX_INVENTORY:items(name)
    return ox_inventory:Items(name)
end

function OX_INVENTORY:getItemCount(item)
    return ox_inventory:GetItemCount(item)
end

return OX_INVENTORY