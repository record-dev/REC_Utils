
---[[
---     Support CUSTOM
---     fallback when no framework is detected, fill it in for your own framework
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local CUSTOM = {}

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

return CUSTOM
