
---[[
---     Support ESX
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.esx then
    return
end

---@type REC_Utils.Server.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local ESX = {}

---@type table
local esx = exports.es_extended:getSharedObject()

---[[
--- map an xPlayer onto the PlayerData shape
--- ESX has no standard onDuty, so an undefined value counts as on duty
---]]
---@param xPlayer table
---@return REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData
local function toPlayerData(xPlayer)
    local job = xPlayer.job or {}

    return {
        source = xPlayer.source,
        citizenId = xPlayer.identifier,
        charinfo = {
            firstname = xPlayer.variables?.firstName or "",
            lastname = xPlayer.variables?.lastName or "",
        },
        job = {
            name = job.name or "unemployed",
            label = job.label or job.name or "unemployed",
            grade = {
                level = job.grade or 0,
            },
            onduty = job.onDuty ~= false,
        },
    }
end

---[[
--- Get all players
---]]
function ESX:getPlayers()

    ---@type table[]
    local xPlayers = esx.GetExtendedPlayers() or {}

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return[]
    local players = {}
    for _, xPlayer in pairs(xPlayers) do
        players[#players+1] = {
            PlayerData = toPlayerData(xPlayer),
        }
    end

    return players
end

---[[
--- Get player object
---]]
function ESX:getPlayerData(playerId)

    ---@type table|nil
    local xPlayer = esx.GetPlayerFromId(playerId)

    -- exists check
    if xPlayer == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return nil
    end

    return toPlayerData(xPlayer)
end

---[[
--- Get citizenId
---]]
function ESX:getCitizenIdByPlayerId(playerId)

    local playerData = self:getPlayerData(playerId)
    if playerData == nil then
        print(("^1failed to get playerObject... playerId: %d^0"):format(playerId))
        return nil
    end

    return playerData.citizenId
end

---[[
--- ESX account names mapped onto the shared currency kinds
---]]
---@type table<string, REC_Utils.Server.Modules.Framework.MoneyTypes>
local accountNameToMoneyType = {
    money = "cash",
    bank = "bank",
    black_money = "black_money",
}

---[[
--- Get every currency the player holds
--- ESX keeps them as accounts, so the account name is renamed to the shared kind
---]]
function ESX:getMoneys(playerId)

    ---@type table|nil
    local xPlayer = esx.GetPlayerFromId(playerId)

    -- exists check
    if xPlayer == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return nil
    end

    ---@type { name: string, money: integer, }[]|nil
    local accounts = xPlayer.accounts
    if accounts == nil then
        return nil
    end

    ---@type table<REC_Utils.Server.Modules.Framework.MoneyTypes, integer>
    local moneys = {}
    for _, account in pairs(accounts) do

        local moneyType = accountNameToMoneyType[account.name]
        if moneyType == nil then
            goto continue
        end

        moneys[moneyType] = account.money or 0

        ::continue::
    end

    return moneys
end

---[[
--- Get one currency the player holds
---]]
function ESX:getMoney(playerId, moneyType)

    local moneys = self:getMoneys(playerId)
    if moneys == nil then
        return nil
    end

    return moneys[moneyType]
end

---[[
--- Check if you have a job
---]]
function ESX:hasJob(playerId, job, grades, onDutyOnly)
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
---]]
function ESX:getJobs()

    ---@type table<string, table>
    local esxJobs = esx.GetJobs() or {}

    ---@type table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
    local jobs = {}
    for name, job in pairs(esxJobs) do
        jobs[name] = {
            label = job.label or name,
            type = job.type,
        }
    end

    return jobs
end

function ESX:doesRequiredJobsExist(requiredJobs, needed)

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

function ESX:setOnPlayerLoaded(onPlayerLoaded)
    ---@param src integer
    AddEventHandler("esx:playerLoaded", function (src)
        onPlayerLoaded(src)
    end)
end

function ESX:setOnPlayerUnLoaded(onPlayerUnLoaded)
    ---@param src integer
    AddEventHandler("esx:playerDropped", function (src)
        onPlayerUnLoaded(src)
    end)
end

---[[
---     ESX has no single money event, so both sides are wired up
---     Account names are mapped onto the shared kinds ("money" -> "cash").
---     Event names differ between ESX builds: check yours if nothing arrives.
---]]
function ESX:setOnMoneyChange(onMoneyChange)

    ---@type table<string, REC_Utils.Server.Modules.Framework.MoneyTypes>
    local accountMapping = {
        money = "cash",
        bank = "bank",
        black_money = "black_money",
    }

    ---@param isRemove boolean
    ---@return fun(src: integer, account: string, amount: integer, reason?: string)
    local function handler(isRemove)
        return function (src, account, amount, reason)

            local moneyType = accountMapping[account]
            if moneyType == nil then
                return
            end

            if type(amount) ~= "number" or amount == 0 then
                return
            end

            onMoneyChange({
                source = src,
                moneyType = moneyType,
                amount = math.abs(amount),
                isRemove = isRemove,
                reason = type(reason) == "string" and reason ~= "" and reason or "unknown",
            })
        end
    end

    AddEventHandler("esx:addAccountMoney", handler(false))
    AddEventHandler("esx:removeAccountMoney", handler(true))
end

return ESX
