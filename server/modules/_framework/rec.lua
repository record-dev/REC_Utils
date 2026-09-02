
---[[
---     Support REC_Core
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local ready = require "@REC_Utils.server.modules._framework._ready"

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.rec then
    return
end

---@type REC_Utils.Server.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local REC = {}

REC.getResourceName, REC.isReady, REC.waitUntilReady = ready("REC_Core")

local recCore = exports.REC_Core

---[[
---     REC_Core snapshot -> the shape every adapter returns
---]]
---@param character REC_Core.Server.Character
---@return REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData
local function toPlayerData(character)

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData
    return {
        source = character.playerId,
        citizenId = character.citizenId,
        charinfo = {
            firstname = character.charinfo.firstname,
            lastname = character.charinfo.lastname,
        },
        job = {
            name = character.job.name,
            label = character.job.label,
            grade = {
                level = character.job.grade.level,
            },
            onduty = character.job.onDuty == true,
        },
    }
end

function REC:getPlayers()

    ---@type REC_Core.Server.Character[]
    local characters = recCore:getPlayers() or {}

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return[]
    local players = {}

    for _, character in ipairs(characters) do
        players[#players+1] = {
            PlayerData = toPlayerData(character),
        }
    end

    return players
end

---[[
--- Get player object
---]]
function REC:getPlayerData(playerId)

    ---@type REC_Core.Server.Character|nil
    local character = recCore:getPlayerData(playerId)
    if character == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return nil
    end

    return toPlayerData(character)
end

---[[
--- Get citizenId
---]]
function REC:getCitizenIdByPlayerId(playerId)
    return recCore:getCitizenIdByPlayerId(playerId)
end

---[[
--- Get every currency the player holds
--- REC_Core account names are whatever config.accounts says, they pass through as-is
---]]
function REC:getMoneys(playerId)

    ---@type table<string, integer>|nil
    local moneys = recCore:getMoneys(playerId)
    if moneys == nil then
        return nil
    end

    return moneys
end

---[[
--- Get one currency the player holds
---]]
function REC:getMoney(playerId, moneyType)

    local moneys = self:getMoneys(playerId)
    if moneys == nil then
        return nil
    end

    return moneys[moneyType]
end

---[[
--- Check if you have a job
---]]
function REC:hasJob(playerId, job, grades, onDutyOnly)
    return recCore:hasJob(playerId, job, grades, onDutyOnly == true) == true
end

function REC:getJobs()

    ---@type table<string, REC_Core.Shared.Groups.Label>
    local jobs = recCore:getJobs() or {}

    ---@type table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
    local result = {}

    for name, job in pairs(jobs) do
        result[name] = {
            label = job.label,
            type = job.type,
        }
    end

    return result
end

function REC:doesRequiredJobsExist(requiredJobs, needed)

    local count = 0

    for name, requiredJobInfo in pairs(requiredJobs) do

        local grades = next(requiredJobInfo.ranks) ~= nil and requiredJobInfo.ranks or nil

        count = count + (recCore:countPlayersByJob(name, grades, requiredJobInfo.onDutyOnly == true) or 0)

        if count >= needed then
            break
        end
    end

    return count >= needed
end

function REC:setOnPlayerLoaded(onPlayerLoaded)

    ---@param src integer
    AddEventHandler("REC_Core:server:onPlayerLoaded", function (src)
        onPlayerLoaded(src)
    end)
end

function REC:setOnPlayerUnLoaded(onPlayerUnLoaded)

    ---@param src integer
    AddEventHandler("REC_Core:server:onPlayerUnloaded", function (src)
        onPlayerUnLoaded(src)
    end)
end

---[[
---     REC_Core emits (source, payload) with the delta signed and the reason always set
---]]
function REC:setOnMoneyChange(onMoneyChange)

    ---@param src integer
    ---@param payload REC_Core.Server.Main.MoneyChange.Payload
    AddEventHandler("REC_Core:server:onMoneyChange", function (src, payload)

        if type(payload) ~= "table" or type(payload.delta) ~= "number" or payload.delta == 0 then
            return
        end

        onMoneyChange({
            source = src,
            moneyType = payload.account,
            amount = math.abs(payload.delta),
            isRemove = payload.delta < 0,
            reason = payload.reason,
        })
    end)
end

---[[
---     Character table layout
---     The inventory is the inventory resource's own, so inventoryColumn stays nil.
---]]
function REC:characterSchema()
    return {
        table = "rec_core_characters",
        citizenIdColumn = "citizenId",
        moneyColumn = "money",
        moneyKeys = {
            cash = "cash",
            bank = "bank",
            black_money = "black_money",
            crypto = "crypto",
        },
        lastLoginColumn = "lastLoggedOutAt",
        nameJsonColumn = "charinfo",
        nameJsonKeys = { "firstname", "lastname", },
    }
end

---[[
---     REC_Core keeps no vehicle table
---]]
function REC:vehicleSchema()
    return nil
end

return REC
