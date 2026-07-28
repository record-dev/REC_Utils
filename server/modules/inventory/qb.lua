
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework
local inventory = apiShCfg.inventory

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes
local invTypes = apiShEnums.InventoryTypes

if inventory ~= invTypes.qb then
    return
end

---@type REC_Utils.Server.Modules.Inventory
---@diagnostic disable-next-line: missing-fields
local QB_INVENTORY = {}

local qb_inventory = exports["qb-inventory"]

function QB_INVENTORY:items(name)
    if framework == frameworkTypes.qbox then
        error("QBox does not have a shared item list.")
    elseif framework == frameworkTypes.qb then
        if name == nil then
            return exports["qb-core"]:GetCoreObject({ "Shared", })?.Shared?.Items
        else
            return exports["qb-core"]:GetCoreObject({ "Shared", })?.Shared?.Items[name]
        end
    end
end

function QB_INVENTORY:getItem(inv, item, metaData)

    local inventory = qb_inventory:GetInventory(inv)
    if inventory == nil or inventory == 0 then
        return nil
    end

    local items = (function ()
        if type(item) == "string" then
            return { item, }
        elseif type(item) == "table" then
            return item
        end
    end)()

    ---@type table<integer, REC_Utils.Server.Modules.Inventory.GetItem.Return>
    local resultItems = {}

    ---@type table<string, integer>
    local itemKeyToTableIndex = {}
    for _, name in ipairs(items) do
        for _, invItem in ipairs(inventory.items) do
            if invItem.name == name then

                local tableIndex = itemKeyToTableIndex[name]
                if tableIndex == nil then
                    itemKeyToTableIndex[name] = #resultItems + 1
                    resultItems[itemKeyToTableIndex[name]] = {
                        name = name,
                        amount = 0,
                        weight = invItem.weight,
                        stack = invItem.stack,
                    }
                end

                resultItems[itemKeyToTableIndex[name]].amount = resultItems[itemKeyToTableIndex[name]].amount + invItem.count
            end
        end
    end

    return resultItems
end

function QB_INVENTORY:getItemCount(playerId, item)
    return qb_inventory:GetItemCount(playerId, item)
end

function QB_INVENTORY:getInventory(inv)
    return qb_inventory:GetInventory(inv)
end

function QB_INVENTORY:openInventory(playerId, inv)
    qb_inventory:OpenInventory(playerId, inv)
    return true
end

function QB_INVENTORY:addItem(inv, item, amount, metaData, slot, cb)
    local items = (function ()
        if type(item) == "string" then
            return { item, }
        elseif type(item) == "table" then
            return item
        end
    end)()

    for _, name in ipairs(items) do
        qb_inventory:AddItem(inv, name, amount, slot, metaData)
    end

    return true
end

function QB_INVENTORY:removeItem(inv, item, amount, metaData, slot)
    return qb_inventory:RemoveItem(inv, item, amount, slot)
end

function QB_INVENTORY:canCarryItem(inv, item)
    local items = (function ()
        if type(item) == "string" then
            return { item, }
        elseif type(item) == "table" then
            return item
        end
    end)()

    for _, item in ipairs(items) do
        if qb_inventory:CanAddItem(inv, item.name, item.amount) == false then
            return false
        end
    end

    return true
end

function QB_INVENTORY:registerStash(id, label, slots, maxWeight, owner, groups, coords)
    return qb_inventory:CreateInventory(id, {
        label = label,
        maxweight = maxWeight,
        slots = slots,
    })
end

function QB_INVENTORY:createTemporaryStash(properties)
    error("Not implemented yet.")
end

function QB_INVENTORY:clearInventory(inv)
    return qb_inventory:ClearStash(inv)
end

return QB_INVENTORY