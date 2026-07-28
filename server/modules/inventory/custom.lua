
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local inventory = apiShCfg.inventory

local apiShEnums = shApi.Enums
local invTypes = apiShEnums.InventoryTypes

if inventory ~= invTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Inventory
---@diagnostic disable-next-line: missing-fields
local CUSTOM_INVENTORY = {}

function CUSTOM_INVENTORY:items(name)
    return 
end

function CUSTOM_INVENTORY:getInventory(inv)
    return 
end

function CUSTOM_INVENTORY:openInventory(playerId, inv)

    

    return true
end

function CUSTOM_INVENTORY:getItem(inv, item, metaData)
    return 
end

function CUSTOM_INVENTORY:getItemCount(playerId, item)
    return 0
end

function CUSTOM_INVENTORY:addItem(inv, item, amount, metaData, slot, cb)



    return true
end

function CUSTOM_INVENTORY:removeItem(inv, item, amount, metaData, slot)

    

    return true
end

function CUSTOM_INVENTORY:canCarryItem(inv, item)



    return true
end

function CUSTOM_INVENTORY:registerStash(id, label, slots, maxWeight, owner, groups, coords)

    

    return true
end

function CUSTOM_INVENTORY:createTemporaryStash(properties)

    

    return ""
end

function CUSTOM_INVENTORY:clearInventory(inv)
    
end

return CUSTOM_INVENTORY