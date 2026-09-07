
---[[
---     Support QBCORE
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local ready = require "@REC_Utils.server.modules._framework._ready"

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.qb then
    return
end

---@type REC_Utils.Client.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local QB = {}

QB.getResourceName, QB.isReady, QB.waitUntilReady = ready("qb-core")

function QB:doesRequiredJobsExist()

end

---[[
--- Check if you are in a gang
--- qb-core keeps gang membership on PlayerData.gang, the same shape as job
---]]
function QB:hasGang(playerId, gang, ranks)

    ---@type table
    local player = exports["qb-core"]:GetCoreObject().Functions.GetPlayer(playerId)
    if player == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return false
    end

    local playerGang = player.PlayerData?.gang

    if type(gang) == "table" then

        local gangFounded = false --[[@as boolean]]
        for _, g in ipairs(gang) do
            if playerGang?.name == g then
                gangFounded = true
                break
            end
        end

        if gangFounded == false then
            return false
        end
    else
        if playerGang?.name ~= gang then
            return false
        end
    end

    if ranks ~= nil then
        if ranks[playerGang?.grade.level] ~= true then
            return false
        end
    end

    return true
end

---[[
--- qb-core keeps the gang list on Shared.Gangs, not an export
---]]
function QB:getGangs()

    ---@type table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
    local gangs = {}

    ---@type table<string, table>|nil
    local sharedGangs = exports["qb-core"]:GetCoreObject().Shared.Gangs
    if sharedGangs == nil then
        return gangs
    end

    for name, gangInfo in pairs(sharedGangs) do
        gangs[name] = { label = gangInfo.label or name, type = "gang" }
    end

    return gangs
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

---[[
--- Add money to one of the player's currencies
--- qb-core already names its keys cash / bank / crypto, so moneyType passes through as-is
---]]
function QB:addMoney(playerId, amount, moneyType)

    ---@type table
    local player = exports["qb-core"]:GetCoreObject().Functions.GetPlayer(playerId)
    if player == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return false
    end

    return player.Functions.AddMoney(moneyType or "bank", amount) == true
end

---[[
--- Remove money from one of the player's currencies
---]]
function QB:removeMoney(playerId, amount, moneyType)

    ---@type table
    local player = exports["qb-core"]:GetCoreObject().Functions.GetPlayer(playerId)
    if player == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return false
    end

    return player.Functions.RemoveMoney(moneyType or "bank", amount) == true
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


---[[
---     Character table layout
---     Read by resources that count items or money across every character, online or
---     not. nil when this framework keeps no table worth walking.
---]]
function QB:characterSchema()
    return {
        table = "players",
        citizenIdColumn = "citizenid",
        inventoryColumn = "inventory",
        moneyColumn = "money",
        moneyKeys = {
            cash = "cash",
            bank = "bank",
            black_money = "black_money",
            crypto = "crypto",
        },
        lastLoginColumn = "last_logged_out",
        nameJsonColumn = "charinfo",
        nameJsonKeys = { "firstname", "lastname", },
    }
end

---[[
---     Owned vehicles, when the framework keeps the storage on the vehicle row
---]]
function QB:vehicleSchema()
    return {
        table = "player_vehicles",
        citizenIdColumn = "citizenid",
        itemColumns = { "glovebox", "trunk", },
    }
end

return QB
