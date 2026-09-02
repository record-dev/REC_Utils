
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

---@type REC_Utils.Client.Modules.Inventory
---@diagnostic disable-next-line: missing-fields
local QB_INVENTORY = {}

local qb_core = exports["qb-core"]
local qb_inventory = exports["qb-inventory"]

function QB_INVENTORY:items(name)
    if framework == frameworkTypes.qbx then
        error("QBox does not have a shared item list.")
    elseif framework == frameworkTypes.qb then
        if name == nil then
            return qb_core:GetCoreObject({ "Shared", })?.Shared?.Items
        else
            return qb_core:GetCoreObject({ "Shared", })?.Shared?.Items[name]
        end
    end
end

function QB_INVENTORY:getItemCount(item)
    error("getItemCount is not supported in qb-inventory, use items() instead to get the item and its count.")
end

function QB_INVENTORY:setIsBusy(isBusy)
    if isBusy == nil or type(isBusy) ~= "boolean" then
        return false
    end

    LocalPlayer.state:set("inv_busy", isBusy, true)
    return true
end

return QB_INVENTORY