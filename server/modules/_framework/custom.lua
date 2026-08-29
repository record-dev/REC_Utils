
---[[
---     Support CUSTOM
---     fallback when no framework is detected, fill it in for your own framework
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local ready = require "@REC_Utils.server.modules._framework._ready"

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local CUSTOM = {}

CUSTOM.getResourceName, CUSTOM.isReady, CUSTOM.waitUntilReady = ready(nil)

---[[
--- Get all players
---]]
function CUSTOM:getPlayers()

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return[]
    local players = {}

    -- collect every player from your framework here
    -- players[#players+1] = { PlayerData = self:getPlayerData(src) }

    return players
end

---[[
--- Get player object
---]]
function CUSTOM:getPlayerData(playerId)

    -- fetch the player info from your framework here and return it in the shape below
    -- return {
    --     source = playerId,
    --     citizenId = "",
    --     charinfo = {
    --         firstname = "",
    --         lastname = "",
    --     },
    --     job = {
    --         name = "unemployed",
    --         label = "Unemployed",
    --         grade = {
    --             level = 0,
    --         },
    --         onduty = false,
    --     },
    -- }

    return nil
end

---[[
--- Get citizenId
---]]
function CUSTOM:getCitizenIdByPlayerId(playerId)

    local playerData = self:getPlayerData(playerId)
    if playerData == nil then
        print(("^1failed to get playerObject... playerId: %d^0"):format(playerId))
        return nil
    end

    return playerData.citizenId
end

---[[
--- Get every currency the player holds
--- return only the kinds your framework actually has, callers read them with `or 0`
---]]
function CUSTOM:getMoneys(playerId)

    -- fetch the balances from your framework here and return them in the shape below
    -- return {
    --     cash = 0,
    --     bank = 0,
    --     black_money = 0,
    --     crypto = 0,
    -- }

    return nil
end

---[[
--- Get one currency the player holds
---]]
function CUSTOM:getMoney(playerId, moneyType)

    local moneys = self:getMoneys(playerId)
    if moneys == nil then
        return nil
    end

    return moneys[moneyType]
end

---[[
--- Check if you have a job
---]]
function CUSTOM:hasJob(playerId, job, grades, onDutyOnly)
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
function CUSTOM:getJobs()

    ---@type table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
    local jobs = {}

    -- fill in the job list from your framework here
    -- jobs["police"] = { label = "Police", type = "leo" }

    return jobs
end

function CUSTOM:doesRequiredJobsExist(requiredJobs, needed)

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

function CUSTOM:setOnPlayerLoaded(onPlayerLoaded)
    -- replace this with your framework's load event
    -- ---@param src integer
    -- AddEventHandler("xxx:playerLoaded", function (src)
    --     onPlayerLoaded(src)
    -- end)
end

function CUSTOM:setOnPlayerUnLoaded(onPlayerUnLoaded)
    -- replace this with your framework's unload event
    -- ---@param src integer
    -- AddEventHandler("xxx:playerDropped", function (src)
    --     onPlayerUnLoaded(src)
    -- end)
end

---[[
---     Point this at whatever your framework emits
---     The handler expects a normalized change, see the MoneyChange class in annotations.lua.
---]]
function CUSTOM:setOnMoneyChange(onMoneyChange)
    print("^3[REC_Utils] custom framework has no money change hook wired up, flow tracking stays empty^0")
end


---[[
---     Character table layout
---     Read by resources that count items or money across every character, online or
---     not. Fill it in for your own framework, the same as the methods above.
---]]
function CUSTOM:characterSchema()

    -- describe the table one row per character lives in
    -- return {
    --     table = "players",
    --     citizenIdColumn = "citizenid",
    --     -- carried inventory as a JSON array, nil when the inventory resource
    --     -- keeps it in a table of its own (ox_inventory does)
    --     inventoryColumn = "inventory",
    --     -- nil counts every row instead of only the recent logins
    --     lastLoginColumn = "last_logged_out",
    --     -- either plain columns joined with a space...
    --     nameColumns = { "firstname", "lastname", },
    --     -- ...or one JSON column and the keys to read out of it
    --     nameJsonColumn = "charinfo",
    --     nameJsonKeys = { "firstname", "lastname", },
    -- }

    return nil
end

---[[
---     Owned vehicles, when the framework keeps the storage on the vehicle row
---]]
function CUSTOM:vehicleSchema()

    -- leave it nil when the inventory resource owns the vehicle storage
    -- return {
    --     table = "player_vehicles",
    --     citizenIdColumn = "citizenid",
    --     itemColumns = { "glovebox", "trunk", },
    -- }

    return nil
end

return CUSTOM
