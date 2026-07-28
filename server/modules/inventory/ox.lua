
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local inventory = apiShCfg.inventory

local apiShEnums = shApi.Enums
local invTypes = apiShEnums.InventoryTypes

if inventory ~= invTypes.ox then
    return
end

---@type REC_Utils.Server.Modules.Inventory
---@diagnostic disable-next-line: missing-fields
local OX_INVENTORY = {}

local ox_inventory = exports.ox_inventory

function OX_INVENTORY:items(name)
    return ox_inventory:Items(name)
end

function OX_INVENTORY:getInventory(inv)
    return ox_inventory:GetInventory(inv)
end

function OX_INVENTORY:openInventory(playerId, inv)
    TriggerClientEvent('ox_inventory:openInventory', playerId, 'stash', inv)
    return true
end

function OX_INVENTORY:getItem(inv, item, metaData)
    return ox_inventory:GetItem(inv, item, metaData)
end

function OX_INVENTORY:getItemCount(playerId, item)
    return ox_inventory:GetItemCount(playerId, item)
end

function OX_INVENTORY:addItem(inv, item, amount, metaData, slot, cb)
    return ox_inventory:AddItem(inv, item, amount, metaData, slot, cb)
end

function OX_INVENTORY:removeItem(inv, item, amount, metaData, slot)
    return ox_inventory:RemoveItem(inv, item, amount, metaData, slot)
end

function OX_INVENTORY:canCarryItem(inv, item)
    local items = (function ()
        if type(item) == "string" then
            return { item, }
        elseif type(item) == "table" then
            return item
        end
    end)()

    local totalWeight = 0 --[[@as number]]
    for _, item in ipairs(items) do
        local itemData = self:items(item.name)
        if itemData == nil then
            goto next
        end

        totalWeight = totalWeight + ( itemData.weight * item.amount )

        ::next::
    end

    return ox_inventory:CanCarryItem(inv, totalWeight)
end

function OX_INVENTORY:registerStash(id, label, slots, maxWeight, owner, groups, coords)
    return ox_inventory:RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
end

function OX_INVENTORY:createTemporaryStash(properties)
    return ox_inventory:CreateTemporaryStash(properties)
end

function OX_INVENTORY:clearInventory(inv, keep)
    return ox_inventory:ClearInventory(inv, keep)
end

return OX_INVENTORY