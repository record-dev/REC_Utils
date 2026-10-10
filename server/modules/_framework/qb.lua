
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

---@type REC_Utils.Server.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local QB = {}

QB.getResourceName, QB.isReady, QB.waitUntilReady = ready("qb-core")

---[[
--- map a qb-core Player onto the PlayerData shape
---]]
---@param player table
---@return REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData
local function toPlayerData(player)
    local playerData = player.PlayerData or {}
    local charinfo = playerData.charinfo or {}
    local job = playerData.job or {}

    return {
        source = playerData.source,
        citizenId = playerData.citizenid,
        charinfo = {
            firstname = charinfo.firstname or "",
            lastname = charinfo.lastname or "",
        },
        job = {
            name = job.name or "unemployed",
            label = job.label or job.name or "unemployed",
            grade = {
                level = tonumber(job.grade?.level) or 0,
            },
            onduty = job.onduty == true,
        },
    }
end

---[[
--- Get all players
--- GetQBPlayers returns the player objects, unlike GetPlayers which only lists sources
---]]
function QB:getPlayers()

    ---@type table<integer, table>
    local qbPlayers = exports["qb-core"]:GetCoreObject().Functions.GetQBPlayers() or {}

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return[]
    local players = {}
    for _, player in pairs(qbPlayers) do
        players[#players+1] = {
            PlayerData = toPlayerData(player),
        }
    end

    return players
end

---[[
--- Get player object
---]]
function QB:getPlayerData(playerId)

    ---@type table|nil
    local player = exports["qb-core"]:GetCoreObject().Functions.GetPlayer(playerId)

    -- exists check
    if player == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return nil
    end

    return toPlayerData(player)
end

---[[
--- Get citizenId
---]]
function QB:getCitizenIdByPlayerId(playerId)

    local playerData = self:getPlayerData(playerId)
    if playerData == nil then
        print(("^1failed to get playerObject... playerId: %d^0"):format(playerId))
        return nil
    end

    return playerData.citizenId
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

---[[
--- Check if you have a job
---]]
function QB:hasJob(playerId, job, grades, onDutyOnly)
    onDutyOnly = onDutyOnly or false

    local playerData = self:getPlayerData(playerId)
    if playerData == nil then
        print(("^1failed to get playerObject... playerId: %d^0"):format(playerId))
        return false
    end

    if type(job) == "table" then

        local jobFounded = false --[[@as boolean]]
        for _, j in ipairs(job) do
            if playerData?.job?.name == j then
                jobFounded = true
                break
            end
        end

        if jobFounded == false then
            return false
        end
    else
        if playerData?.job?.name ~= job then
            return false
        end
    end

    if grades ~= nil then
        if grades[playerData?.job?.grade.level] ~= true then
            return false
        end
    end

    if onDutyOnly == true then
        if playerData.job.onduty == false then
            return false
        end
    end

    return true
end

---[[
--- Get all jobs
--- qb-core keeps the job list on Shared.Jobs, not an export
---]]
function QB:getJobs()

    ---@type table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
    local jobs = {}

    ---@type table<string, table>|nil
    local sharedJobs = exports["qb-core"]:GetCoreObject().Shared.Jobs
    if sharedJobs == nil then
        return jobs
    end

    for name, jobInfo in pairs(sharedJobs) do
        jobs[name] = { label = jobInfo.label or name, type = jobInfo.type, grades = jobInfo.grades, }
    end

    return jobs
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


function QB:doesRequiredJobsExist(requiredJobs, needed)

    local count = 0
    local players = self:getPlayers()
    if players == nil then
        return false
    end
    for _, playerObject in ipairs(players) do
        local playerData = playerObject?.PlayerData
        if playerData == nil then
            goto next
        end

        for key, requiredJobInfo in pairs(requiredJobs) do
            if playerData?.job?.name == key then

                ---@type boolean, boolean
                local checkJobGrade, checkJobDuty = false, false

                local ranks = requiredJobInfo.ranks
                if next(ranks) == nil then
                    checkJobGrade = true
                else
                    if ranks[playerData?.job?.grade.level] == true then
                        checkJobGrade = true
                    end
                end

                -- check onDuty
                if playerData?.job?.onduty == true and requiredJobInfo.onDutyOnly == true then
                    checkJobDuty = true
                elseif requiredJobInfo.onDutyOnly == false then
                    checkJobDuty = true
                end

                if checkJobGrade == true and checkJobDuty == true then
                    count = count + 1
                end

                -- Move to next player when current job applies
                break
            end
        end

        if count >= needed then
            break
        end

        ::next::
    end

    return count >= needed
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
        countKey = apiShCfg.inventory == apiShEnums.InventoryTypes.qb and "amount" or nil,
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
---     qb-inventory keeps trunk / glovebox in its own inventories table, so the stash pass covers them.
---]]
function QB:vehicleSchema()

    if apiShCfg.inventory == apiShEnums.InventoryTypes.qb then
        return nil
    end

    return {
        table = "player_vehicles",
        citizenIdColumn = "citizenid",
        itemColumns = { "glovebox", "trunk", },
    }
end

return QB
