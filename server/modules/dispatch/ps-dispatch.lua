
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local dispatch = apiShCfg.dispatch

local apiShEnums = shApi.Enums
local dispatchTypes = apiShEnums.DispatchTypes

if dispatch ~= dispatchTypes.ps then
    return
end

---@type REC_Utils.Server.Modules.Dispatch
---@diagnostic disable-next-line: missing-fields
local DISPATCH_PS_DISPATCH = {}

---@type REC_Utils.Server.Modules.Framework
local framework = require ("@REC_Utils.server.modules._framework." .. apiShCfg.framework)

---[[
---     ps-dispatch:server:notify reads a client source and fails on a server trigger
---     so SendTargetedAlert is used with the on duty players of the target jobs
---     the payload follows what ps-dispatch CustomAlert builds, the client reads code and alert.length (minutes) unguarded
---]]
function DISPATCH_PS_DISPATCH:call(config)

    local jobs = config.jobs ~= nil and #config.jobs > 0 and config.jobs or { "leo" }

    ---@type table<string, true>
    local jobSet = {}
    for _, job in ipairs(jobs) do
        jobSet[job] = true
    end

    -- ps-dispatch matches a call's jobs against both job.name and job.type
    local jobInfos = framework:getJobs()

    ---@type integer[]
    local targets = {}
    for _, player in ipairs(framework:getPlayers()) do
        local playerData = player.PlayerData
        local jobType = jobInfos[playerData.job.name]?.type
        local isTarget = jobSet[playerData.job.name] == true or (jobType ~= nil and jobSet[jobType] == true)

        if isTarget == true and playerData.job.onduty == true then
            targets[#targets+1] = playerData.source
        end
    end

    if #targets == 0 then
        return false
    end

    local payload = {
        message = config.msg,
        information = config.description,
        code = config.code or "10-80",
        codeName = config.codeName or "NONE",
        icon = config.icon or "fas fa-question",
        priority = config.priority == "high" and 1 or config.priority == "medium" and 2 or 3,
        coords = config.coords,
        jobs = jobs,
        alertTime = math.max(math.ceil(config.duration / 1000), 1),
        addToList = true,
        alert = {
            radius = config.radius or 0,
            sprite = config.sprite or 1,
            color = config.spriteColor or 1,
            scale = config.spriteScale or 0.5,
            length = math.max(config.duration / 60000, 0.1),
            sound = config.soundName or "Lose_1st",
            sound2 = config.soundDict or "GTAO_FM_Events_Soundset",
            offset = false,
            flash = false,
        },
    }

    return exports["ps-dispatch"]:SendTargetedAlert(targets, payload) == true
end

return DISPATCH_PS_DISPATCH