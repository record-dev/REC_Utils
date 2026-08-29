
---[[
---     Support QBOX
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.qbx then
    return
end

---@type REC_Utils.Server.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local QBOX = {}

local qbx_core = exports.qbx_core

function QBOX:getPlayers()
    local qbPlayers = qbx_core:GetQBPlayers()

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return[]
    local players = {}
    for _, v in pairs(qbPlayers) do
        local playerData = v.PlayerData
        players[#players+1] = {
            PlayerData = {
                source = playerData.source,
                citizenId = playerData.citizenid,
                charinfo = {
                    firstname = playerData.charinfo.firstname,
                    lastname = playerData.charinfo.lastname,
                },
                job = {
                    name = playerData.job.name,
                    label = playerData.job.label,
                    grade = playerData.job.grade,
                    onduty = playerData.job.onduty,
                },
            },
        }
    end

    return next(players) ~= nil and players or {}
end

---[[
--- Get player object
---]]
function QBOX:getPlayerData(playerId)

    ---@type table
    local player = qbx_core:GetPlayer(playerId)

    -- Sky check
    if player == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return nil
    end

    local playerData = player.PlayerData

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData
    return {
        source = playerData.source,
        citizenId = playerData.citizenid,
        charinfo = {
            firstname = playerData.charinfo.firstname,
            lastname = playerData.charinfo.lastname,
        },
        job = {
            name = playerData.job.name,
            label = playerData.job.label,
            grade = playerData.job.grade,
            onduty = playerData.job.onduty,
        },
    }
end

---[[
--- Get citizenId
---]]
function QBOX:getCitizenIdByPlayerId(playerId)

    local playerData = self:getPlayerData(playerId)
    if playerData == nil then
        print(("^1failed to get playerObject... playerId: %d^0"):format(playerId))
        return nil
    end

    return playerData.citizenId
end

---[[
--- Get every currency the player holds
--- qbx already names its keys cash / bank / crypto, so they pass through as-is
---]]
function QBOX:getMoneys(playerId)

    ---@type table
    local player = qbx_core:GetPlayer(playerId)

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
function QBOX:getMoney(playerId, moneyType)

    local moneys = self:getMoneys(playerId)
    if moneys == nil then
        return nil
    end

    return moneys[moneyType]
end

---[[
--- Check if you have a job
---]]
function QBOX:hasJob(playerId, job, grades, onDutyOnly)
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

function QBOX:getJobs()
    return qbx_core:GetJobs()
end

function QBOX:doesRequiredJobsExist(requiredJobs, needed)

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
                    if requiredJobInfo.ranks[playerData?.job?.grade.level] == true then
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

function QBOX:setOnPlayerLoaded(onPlayerLoaded)
    RegisterNetEvent("QBCore:Server:OnPlayerLoaded", function (...)
        local src = source
        onPlayerLoaded(src)
    end)
end

---not work. do not use thie
function QBOX:setOnPlayerUnLoaded(onPlayerUnLoaded)
    ---@param src integer
    AddEventHandler("QBCore:Server:OnPlayerUnload", function (src)
        onPlayerUnLoaded(src)
    end)
end

---[[
---     qbx emits (source, moneyType, amount, actionType, reason)
---     actionType "set" carries the new balance rather than a delta and the event
---     does not pass the difference, so it cannot be turned into a movement.
---]]
function QBOX:setOnMoneyChange(onMoneyChange)

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
function QBOX:characterSchema()
    return {
        table = "players",
        citizenIdColumn = "citizenid",
        inventoryColumn = "inventory",
        lastLoginColumn = "last_logged_out",
        nameJsonColumn = "charinfo",
        nameJsonKeys = { "firstname", "lastname", },
    }
end

---[[
---     Owned vehicles, when the framework keeps the storage on the vehicle row
---]]
function QBOX:vehicleSchema()
    return {
        table = "player_vehicles",
        citizenIdColumn = "citizenid",
        itemColumns = { "glovebox", "trunk", },
    }
end

return QBOX
