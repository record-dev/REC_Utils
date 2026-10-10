
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

local temporaryStashCount = 0

function QB_INVENTORY:items(name)
    if framework == frameworkTypes.qbx then
        error("QBox does not have a shared item list.")
    elseif framework == frameworkTypes.qb then
        if name == nil then
            return exports["qb-core"]:GetCoreObject({ "Shared", })?.Shared?.Items
        else
            return exports["qb-core"]:GetCoreObject({ "Shared", })?.Shared?.Items[name]
        end
    end
end

---[[
---     Items of a player or a stash / drop, keyed by slot
---     Only a number is a player id, a string is always a stash / drop identifier (same as ox_inventory)
---]]
---@param inv integer|string
---@return table<integer|string, table>|nil items
---@return boolean isPlayer
local function resolveItems(inv)

    if type(inv) == "number" then
        local player = exports["qb-core"]:GetPlayer(inv)
        return player?.PlayerData?.items, true
    end

    return qb_inventory:GetInventory(inv)?.items, false
end

---[[
---     ox_inventory turns a string metadata into { type = string }
---]]
---@param metaData string|table|nil
---@return table|nil
local function assertMetaData(metaData)
    if metaData ~= nil and type(metaData) ~= "table" then
        return { type = metaData, }
    end

    return metaData
end

---[[
---     Shared item definition, nil when the framework has no qb-core shared list (qbx)
---]]
---@param name string
---@return table|nil
local function getSharedItem(name)
    local success, shared = pcall(function ()
        return exports["qb-core"]:GetShared("Items", name)
    end)

    if success == false or type(shared) ~= "table" then
        return nil
    end

    return shared
end

---[[
---     Name list of the item argument, a string and a list are both accepted
---]]
---@param item string|string[]
---@return string[]
local function toNameList(item)
    if type(item) == "string" then
        return { item, }
    elseif type(item) == "table" then
        return item
    end
    return {}
end

---[[
---     Whether the stored info carries every key of the filter
---]]
---@param info table|nil
---@param filter string|table|nil
---@return boolean
local function matchesMetaData(info, filter)
    if type(filter) ~= "table" then
        return true
    end

    for key, value in pairs(filter) do
        if type(info) ~= "table" or info[key] ~= value then
            return false
        end
    end

    return true
end

function QB_INVENTORY:getItem(inv, item, metaData)

    -- an unresolved inventory still answers count 0, like ox_inventory
    local items = resolveItems(inv)
    if type(items) ~= "table" then
        items = {}
    end

    local filter = assertMetaData(metaData)

    ---@param name string
    ---@return REC_Utils.Server.Modules.Inventory.GetItem.Return
    local function count(name)
        local shared = getSharedItem(name)

        ---@type REC_Utils.Server.Modules.Inventory.GetItem.Return
        local result = {
            name = name,
            count = 0,
            weight = shared?.weight,
            stack = (function ()
                if shared == nil then
                    return nil
                end
                return shared.unique ~= true
            end)(),
        }

        for _, invItem in pairs(items) do
            if type(invItem) ~= "table" or invItem.name ~= name then
                goto continue
            end

            if matchesMetaData(invItem.info, filter) == false then
                goto continue
            end

            result.count = result.count + (tonumber(invItem.amount) or 0)
            result.weight = invItem.weight or result.weight

            ::continue::
        end

        -- kept for callers written against the old qb key
        result.amount = result.count

        return result
    end

    -- a single name answers a single entry, a list answers a list
    if type(item) == "string" then
        return count(item)
    end

    ---@type REC_Utils.Server.Modules.Inventory.GetItem.Return[]
    local results = {}
    for _, name in ipairs(toNameList(item)) do
        results[#results+1] = count(name)
    end

    return results
end

function QB_INVENTORY:getItemCount(playerId, item)
    return qb_inventory:GetItemCount(playerId, item) or 0
end

function QB_INVENTORY:getInventory(inv)

    local items, isPlayer = resolveItems(inv)
    if type(items) ~= "table" then
        return false
    end

    -- same slot keyed shape as ox_inventory, weight is the whole stack
    ---@type table<integer, { name: string, label?: string, count: integer, slot: integer, metadata?: table, weight: number, }>
    local converted = {}
    local weight = 0
    for key, invItem in pairs(items) do
        if type(invItem) ~= "table" or invItem.name == nil then
            goto continue
        end

        local slot = tonumber(invItem.slot) or tonumber(key)
        local amount = tonumber(invItem.amount) or 0
        local stackWeight = (tonumber(invItem.weight) or 0) * amount

        converted[slot] = {
            name = invItem.name,
            label = invItem.label,
            count = amount,
            slot = slot,
            metadata = type(invItem.info) == "table" and next(invItem.info) ~= nil and invItem.info or nil,
            weight = stackWeight,
        }
        weight = weight + stackWeight

        ::continue::
    end

    -- player capacity lives in the qb-inventory config, which is not reachable from here
    if isPlayer == true then
        return {
            id = tostring(inv),
            label = GetPlayerName(inv),
            type = "player",
            weight = weight,
            items = converted,
            owner = true,
        }
    end

    local stash = qb_inventory:GetInventory(inv)
    return {
        id = tostring(inv),
        label = stash.label,
        type = "stash",
        slots = stash.slots,
        weight = weight,
        maxWeight = stash.maxweight,
        items = converted,
        owner = false,
    }
end

function QB_INVENTORY:getInventoryItems(inv)

    ---@type table<integer, { name: string, count: integer, slot?: integer, metadata?: table, }>
    local result = {}

    local items = resolveItems(inv)
    if type(items) ~= "table" then
        return result
    end

    for slot, invItem in pairs(items) do
        if type(invItem) ~= "table" or invItem.name == nil then
            goto continue
        end

        result[#result+1] = {
            name = invItem.name,
            count = tonumber(invItem.amount) or 0,
            slot = invItem.slot or slot,
            metadata = type(invItem.info) == "table" and next(invItem.info) ~= nil and invItem.info or nil,
        }

        ::continue::
    end

    table.sort(result, function (a, b)
        return (a.slot or 0) < (b.slot or 0)
    end)

    return result
end

function QB_INVENTORY:openInventory(playerId, inv)
    qb_inventory:OpenInventory(playerId, inv)
    return true
end

function QB_INVENTORY:openPlayerInventory(playerId, targetId)
    qb_inventory:OpenInventoryById(playerId, targetId)
    return true
end

function QB_INVENTORY:addItem(inv, item, amount, metaData, slot, cb)

    -- qb-inventory takes the info as a table only
    local info = assertMetaData(metaData)

    local success, response = true, nil
    for _, name in ipairs(toNameList(item)) do
        if qb_inventory:AddItem(inv, name, amount, slot, info) == false then
            success, response = false, ("failed to add %s"):format(name)
            break
        end
    end

    if cb ~= nil then
        cb(success, response)
    end

    return success, response
end

function QB_INVENTORY:removeItem(inv, item, amount, metaData, slot)

    -- ox_inventory refuses a non-number count as well, there is no default of 1
    if type(amount) ~= "number" or amount <= 0 then
        return false, "invalid_count"
    end

    -- RemoveItem works on one slot at a time, so a stack split over slots is walked here
    if slot ~= nil then
        return qb_inventory:RemoveItem(inv, item, amount, slot)
    end

    local items = resolveItems(inv)
    if type(items) ~= "table" then
        return false, "invalid_inventory"
    end

    local filter = assertMetaData(metaData)

    ---@type { slot: integer, amount: integer, info?: table, }[]
    local stacks = {}
    local total = 0
    for key, invItem in pairs(items) do
        if type(invItem) ~= "table" or invItem.name ~= item then
            goto continue
        end

        if matchesMetaData(invItem.info, filter) == false then
            goto continue
        end

        stacks[#stacks+1] = { slot = tonumber(invItem.slot) or tonumber(key), amount = invItem.amount, info = invItem.info, }
        total = total + invItem.amount

        ::continue::
    end

    if total < amount then
        return false, "not_enough_items"
    end

    table.sort(stacks, function (a, b)
        return a.slot < b.slot
    end)

    ---@type { slot: integer, amount: integer, info?: table, }[]
    local removed = {}
    local remaining = amount
    for _, stack in ipairs(stacks) do
        if remaining <= 0 then
            break
        end

        local take = math.min(remaining, stack.amount)
        if qb_inventory:RemoveItem(inv, item, take, stack.slot) == false then

            -- give back what was already taken so the removal is all or nothing
            for _, done in ipairs(removed) do
                if qb_inventory:AddItem(inv, item, done.amount, done.slot, done.info) == false then
                    print(("^1failed to restore removed item... inv: %s, item: %s, slot: %s, amount: %s^0"):format(tostring(inv), item, tostring(done.slot), tostring(done.amount)))
                end
            end

            return false, "failed_to_remove"
        end

        removed[#removed+1] = { slot = stack.slot, amount = take, info = stack.info, }
        remaining = remaining - take
    end

    return true
end

function QB_INVENTORY:canCarryItem(inv, item)

    -- a single { name, amount } entry is wrapped, a bare name counts as one
    local items = (function ()
        if type(item) == "string" then
            return { { name = item, amount = 1, }, }
        elseif type(item) == "table" and item.name ~= nil then
            return { item, }
        elseif type(item) == "table" then
            return item
        end
        return {}
    end)()

    for _, entry in ipairs(items) do
        if qb_inventory:CanAddItem(inv, entry.name, entry.amount or 1) == false then
            return false
        end
    end

    return true
end

function QB_INVENTORY:registerStash(id, label, slots, maxWeight, owner, groups, coords)
    qb_inventory:CreateInventory(tostring(id), {
        label = label,
        maxweight = maxWeight,
        slots = slots,
    })
    return true
end

-- unlike ox_inventory, qb-inventory saves the stash to the inventories table and never deletes it
function QB_INVENTORY:createTemporaryStash(properties)

    temporaryStashCount = temporaryStashCount + 1
    local id = ("%s_temp_%d_%d"):format(GetCurrentResourceName(), os.time(), temporaryStashCount)

    qb_inventory:CreateInventory(id, {
        label = properties.label,
        maxweight = properties.maxWeight,
        slots = properties.slots,
    })

    -- owner, groups and coords have no equivalent in qb-inventory
    for _, entry in ipairs(properties.items or {}) do
        if qb_inventory:AddItem(id, entry[1], entry[2], nil, entry[3]) == false then
            print(("^3failed to add item to temporary stash... stash: %s, item: %s^0"):format(id, tostring(entry[1])))
        end
    end

    return id
end

function QB_INVENTORY:clearInventory(inv, keep)

    -- ClearInventory is player only, ClearStash is stash only
    if type(inv) == "number" then
        if exports["qb-core"]:GetPlayer(inv) == nil then
            print(("^3player is not founded... playerId: %s^0"):format(tostring(inv)))
            return false
        end

        return qb_inventory:ClearInventory(inv, keep)
    end

    local keepNames = {}
    for _, name in ipairs(toNameList(keep)) do
        keepNames[name] = true
    end

    if next(keepNames) == nil then
        return qb_inventory:ClearStash(inv)
    end

    -- ClearStash cannot keep items, so every other entry is removed by slot
    local items = resolveItems(inv)
    if type(items) ~= "table" then
        return
    end

    for key, invItem in pairs(items) do
        if type(invItem) == "table" and keepNames[invItem.name] == nil then
            qb_inventory:RemoveItem(inv, invItem.name, invItem.amount, tonumber(invItem.slot) or tonumber(key))
        end
    end
end

---[[
---     Stash storage, for resources that count items across the server
---]]
function QB_INVENTORY:stashSchema()
    -- qb-inventory keeps stashes, trunks and gloveboxes in `inventories` (identifier, items)
    -- with no owner or update column, and stores the quantity as amount.
    return {
        table = "inventories",
        nameColumn = "identifier",
        dataColumn = "items",
        countKey = "amount",
    }
end

function QB_INVENTORY:imageSource()
    return {
        resource = "qb-inventory",
        dir = "html/images",
    }
end

---[[
---     qb keeps the sprite name on the shared item itself
---]]
function QB_INVENTORY:itemImages()

    ---@type table<string, string>
    local images = {}

    local items = self:items()
    if type(items) ~= "table" then
        return images
    end

    for name, item in pairs(items) do
        if type(item) == "table" and type(item.image) == "string" then
            images[name] = item.image
        end
    end

    return images
end

---[[
---     Called when a player uses the item
---     Registers it as a usable item on the framework, which keeps one callback per
---     item, and nothing is consumed unless the callback removes it.
---]]
function QB_INVENTORY:onUsedItem(item, onUsedItem)

    ---@param src integer
    ---@param itemData { name: string, slot?: integer, info?: table, }
    local function onUse(src, itemData)
        onUsedItem({
            source = src,
            name = item,
            slot = itemData?.slot,
            metaData = type(itemData?.info) == "table" and next(itemData.info) ~= nil and itemData.info or nil,
        })
    end

    if framework == frameworkTypes.qbx then
        exports.qbx_core:CreateUseableItem(item, onUse)
        return true
    elseif framework == frameworkTypes.qb then
        exports["qb-core"]:GetCoreObject({ "Functions", }).Functions.CreateUseableItem(item, onUse)
        return true
    end

    return false
end

return QB_INVENTORY