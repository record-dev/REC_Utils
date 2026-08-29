
---[[
---     Support QBCORE
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.qb then
    return
end

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local QB = {}

function QB:doesRequiredJobsExist()

end

---[[
--- Get every currency the player holds
--- qb already names its keys cash / bank / crypto, so they pass through as-is
---]]
function QB:getMoneys(playerId)

    ---@type table
    local player = exports["qb-core"]:GetCoreObject().Functions.GetPlayer(playerId)

    -- exists check
    if player == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return nil
    end

    local money = player.PlayerData?.money
    if money == nil then
        return nil
    end

    ---@type table<REC_Utils.Server.Modules.Framework.MoneyTypes, integer>
    local moneys = {}
    for moneyType, amount in pairs(money) do
        if type(amount) == "number" then
            moneys[moneyType] = amount
        end
    end

    return moneys
end

---[[
--- Get one currency the player holds
---]]
function QB:getMoney(playerId, moneyType)

    local moneys = self:getMoneys(playerId)
    if moneys == nil then
        return nil
    end

    return moneys[moneyType]
end

function QB:setOnPlayerLoaded(onPlayerLoaded)
    RegisterNetEvent("QBCore:Server:OnPlayerLoaded", function (...)
        local src = source
        onPlayerLoaded(src)
    end)
end

function QB:setOnPlayerUnLoaded(onPlayerUnLoaded)
    ---@param src integer
    AddEventHandler("QBCore:Server:OnPlayerUnload", function (src)
        onPlayerUnLoaded(src)
    end)
end

---[[
---     qb-core emits the same event shape as qbx
---     actionType "set" carries the new balance rather than a delta, so it is skipped.
---]]
function QB:setOnMoneyChange(onMoneyChange)

    ---@param src integer
    ---@param moneyType REC_Utils.Server.Modules.Framework.MoneyTypes
    ---@param amount integer
    ---@param actionType "add" | "remove" | "set"
    ---@param reason? string
    AddEventHandler("QBCore:Server:OnMoneyChange", function (src, moneyType, amount, actionType, reason)

        if actionType ~= "add" and actionType ~= "remove" then
            return
        end

        if type(amount) ~= "number" or amount == 0 then
            return
        end

        onMoneyChange({
            source = src,
            moneyType = moneyType,
            amount = math.abs(amount),
            isRemove = actionType == "remove",
            reason = type(reason) == "string" and reason ~= "" and reason or "unknown",
        })
    end)
end

return QB