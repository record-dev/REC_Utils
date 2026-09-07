
---@type REC_Utils.Shared.Events
local events = require "@REC_Utils.shared.sh_event"

---@type REC_Utils.Client.Api
local clUtilsApi = require "@REC_Utils.client.cl_api"

RegisterNetEvent(events.client.kill, function (...)
    SetEntityHealth(cache.ped, 0)
end)

RegisterNetEvent(events.client.clothingOpenMenu, function (fullCustomization)
    clUtilsApi.Clothing:openMenu(nil, fullCustomization)
end)

RegisterNetEvent(events.client.clothingLoadOutfit, function (clothingData)
    if clothingData ~= nil then
        clUtilsApi.Clothing:setClothing(clothingData)
    end
end)