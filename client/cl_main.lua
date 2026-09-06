
---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

---@type REC_Utils.Client.Api
local clUtilsApi = require "@REC_Utils.client.cl_api"

RegisterNetEvent(events.client.kill, function (...)
    SetEntityHealth(cache.ped, 0)
end)

---[[
---     Fires once for whichever framework is installed, so callers do not
---     need to know its player loaded event name.
---]]
clUtilsApi.Framework:setOnPlayerLoaded(function ()
    TriggerEvent(events.client.onPlayerLoaded)
end)