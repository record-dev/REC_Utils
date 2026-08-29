
---[[
---     Support OX_CORE
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local framework = apiShCfg.framework

local ready = require "@REC_Utils.server.modules._framework._ready"

local apiShEnums = shApi.Enums
local frameworkTypes = apiShEnums.FrameworkTypes

if framework ~= frameworkTypes.ox then
    return
end

---@type REC_Utils.Server.Modules.Framework
---@diagnostic disable-next-line: missing-fields
local OX = {}

OX.getResourceName, OX.isReady, OX.waitUntilReady = ready("ox_core")

local ox_core = exports.ox_core

---[[
--- map an ox_core group onto the PlayerData.job shape
--- activeGroup wins, otherwise the first group found is used
---]]
---@param playerId integer
---@return REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData.Job
local function getJobFromGroups(playerId)

    ---@type table<string, integer>
    local groups = ox_core:CallPlayer(playerId, "getGroups") or {}

    ---@type string|nil
    local activeGroup = ox_core:CallPlayer(playerId, "get", "activeGroup")

    -- decide the group
    local jobName, jobGrade = (function ()
        if activeGroup ~= nil and groups[activeGroup] ~= nil then
            return activeGroup, groups[activeGroup]
        end
        for name, grade in pairs(groups) do
            return name, grade
        end
        return "unemployed", 0
    end)()

    -- get the label
    local group = ox_core:GetGroup(jobName)

    return {
        name = jobName,
        label = group?.label or jobName,
        grade = {
            level = jobGrade,
        },
        onduty = activeGroup == jobName,
    }
end

---[[
--- Get all players
---]]
function OX:getPlayers()

    ---@type table[]
    local oxPlayers = ox_core:GetPlayers() or {}

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return[]
    local players = {}
    for _, v in pairs(oxPlayers) do
        local playerData = self:getPlayerData(v.source)
        if playerData == nil then
            goto continue
        end

        players[#players+1] = {
            PlayerData = playerData,
        }

        ::continue::
    end

    return players
end

---[[
--- Get player object
---]]
function OX:getPlayerData(playerId)

    ---@type table|nil
    local player = ox_core:GetPlayer(playerId)

    -- exists check
    if player == nil then
        print(("^1failed to get player. playerId: %d^0"):format(playerId))
        return nil
    end

    ---@type REC_Utils.Server.Modules.Framework.GetPlayers.Return.PlayerData
    return {
        source = player.source,
        citizenId = tostring(player.stateId),
        charinfo = {
            firstname = player.firstName,
            lastname = player.lastName,
        },
        job = getJobFromGroups(playerId),
    }
end

---[[
--- Get citizenId
---]]
function OX:getCitizenIdByPlayerId(playerId)

    local playerData = self:getPlayerData(playerId)
    if playerData == nil then
        print(("^1failed to get playerObject... playerId: %d^0"):format(playerId))
        return nil
    end

    return playerData.citizenId
end

---[[
--- DO NOT TOUCH
--- warn only on the first call so a sampling loop cannot flood the console
---]]
---@type boolean
local warnedAboutMoneys = false

---[[
--- Get every currency the player holds
--- ox_core keeps money outside the character object and the API differs per version,
--- so fill this in against the ox_core build you run
---]]
function OX:getMoneys(playerId)

    if warnedAboutMoneys == false then
        warnedAboutMoneys = true
        print("^3getMoneys is not implemented for ox_core. implement it in REC_Utils/server/modules/_framework/ox.lua^0")
    end

    -- resolve the accounts of the character behind playerId and return them in the shape below
    -- return {
    --     cash = 0,
    --     bank = 0,
    -- }

    return nil
end

---[[
--- Get one currency the player holds
---]]
function OX:getMoney(playerId, moneyType)

    local moneys = self:getMoneys(playerId)
    if moneys == nil then
        return nil
    end

    return moneys[moneyType]
end

---[[
--- Check if you have a job
---]]
function OX:hasJob(playerId, job, grades, onDutyOnly)
    onDutyOnly = onDutyOnly or false

    ---@type table<string, integer>|nil
    local groups = ox_core:CallPlayer(playerId, "getGroups")
    if groups == nil then
        print(("^1failed to get groups... playerId: %d^0"):format(playerId))
        return false
    end

    ---@type string|nil
    local activeGroup = ox_core:CallPlayer(playerId, "get", "activeGroup")

    -- find which of the given jobs they belong to
    local jobName, jobGrade = (function ()
        if type(job) == "table" then
            for _, j in ipairs(job) do
                if groups[j] ~= nil then
                    return j, groups[j]
                end
            end
            return nil, nil
        end
        return job, groups[job]
    end)()

    if jobName == nil or jobGrade == nil then
        return false
    end

    if grades ~= nil then
        if grades[jobGrade] ~= true then
            return false
        end
    end

    if onDutyOnly == true then
        if activeGroup ~= jobName then
            return false
        end
    end

    return true
end

---[[
--- Get all groups of job type
---]]
function OX:getJobs()

    ---@type table[]
    local groups = ox_core:GetGroupsByType("job") or {}

    ---@type table<string, REC_Utils.Server.Modules.Framework.GetJobs.Return>
    local jobs = {}
    for _, group in pairs(groups) do
        jobs[group.name] = {
            label = group.label,
            type = group.type,
        }
    end

    return jobs
end

function OX:doesRequiredJobsExist(requiredJobs, needed)

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

        -- ox_core allows several groups, so check all of groups rather than job
        ---@type table<string, integer>
        local groups = ox_core:CallPlayer(playerData.source, "getGroups") or {}

        for key, requiredJobInfo in pairs(requiredJobs) do
            local grade = groups[key]
            if grade ~= nil then

                ---@type boolean, boolean
                local checkJobGrade, checkJobDuty = false, false

                local ranks = requiredJobInfo.ranks
                if next(ranks) == nil then
                    checkJobGrade = true
                else
                    if ranks[grade] == true then
                        checkJobGrade = true
                    end
                end

                -- check onDuty (on duty when activeGroup matches)
                if requiredJobInfo.onDutyOnly == true and playerData?.job?.name == key and playerData?.job?.onduty == true then
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

function OX:setOnPlayerLoaded(onPlayerLoaded)
    ---@param src integer
    AddEventHandler("ox:playerLoaded", function (src)
        onPlayerLoaded(src)
    end)
end

function OX:setOnPlayerUnLoaded(onPlayerUnLoaded)
    ---@param src integer
    AddEventHandler("ox:playerLogout", function (src)
        onPlayerUnLoaded(src)
    end)
end

---[[
---     ox_core has no global money movement event
---     Cash is an ox_inventory item and bank balances live in the accounts table,
---     so nothing generic can be hooked here. Wire your own emitter and call the
---     handler from it when you need the flow figures on ox.
---]]
function OX:setOnMoneyChange(onMoneyChange)
    print("^3[REC_Utils] ox_core exposes no money change event, flow tracking stays empty^0")
end


---[[
---     Character table layout
---     ox_core keeps its character rows in a schema of its own and hands the item
---     storage to ox_inventory.
---]]
function OX:characterSchema()

    -- Not verified against a running ox_core, so it stays off rather than counting
    -- the wrong table. Check the column names against your build, then enable it.
    -- return {
    --     table = "characters",
    --     citizenIdColumn = "stateId",
    --     -- ox_inventory owns the item storage, so the stash pass covers it
    --     inventoryColumn = nil,
    --     lastLoginColumn = "lastPlayed",
    --     nameColumns = { "firstName", "lastName", },
    -- }

    return nil
end

---[[
---     ox_core keeps no item columns on its vehicle rows
---     That storage belongs to ox_inventory, so the stash pass picks it up.
---]]
function OX:vehicleSchema()
    return nil
end

return OX
