
---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

RegisterNetEvent(events.client.kill, function (...)
    SetEntityHealth(cache.ped, 0)
end)