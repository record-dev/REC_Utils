
---@type REC_Utils.Client.Api
local clUtilsApi = require "@REC_Utils.client.cl_api"

RegisterCommand("raycast", function ()
    clUtilsApi.Raycast:toggle()
end, false)

RegisterCommand("sound", function (_, args)
    local sound = args[1]
    if sound == nil or type(sound) ~= "string" then
        return
    end

    TriggerMusicEvent(sound)
end, false)
