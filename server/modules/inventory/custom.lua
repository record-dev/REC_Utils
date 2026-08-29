
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
    return nil
end

function CUSTOM_INVENTORY:getInventory(inv)
    return false
end

function CUSTOM_INVENTORY:openInventory(playerId, inv)

    

    return true
end

function CUSTOM_INVENTORY:getItem(inv, item, metaData)
    return nil
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

---[[
---     Stash storage, for resources that count items across the server
---     Fill it in for your own inventory.
---]]
function CUSTOM_INVENTORY:stashSchema()

    -- describe the table your stashes are stored in
    -- return {
    --     table = "stashes",
    --     nameColumn = "name",
    --     -- citizenId of the owner, a stash with no owner still counts into the
    --     -- totals but cannot be attributed to a character
    --     ownerColumn = "owner",
    --     -- the stored items as a JSON array
    --     dataColumn = "data",
    --     -- nil walks every stash instead of only the recently touched ones
    --     updatedColumn = "lastupdated",
    -- }

    return nil
end

function CUSTOM_INVENTORY:imageSource()
    return nil
end

function CUSTOM_INVENTORY:itemImages()
    return {}
end

return CUSTOM_INVENTORY
