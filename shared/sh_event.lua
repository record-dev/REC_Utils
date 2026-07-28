
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"

---@type string
local prefix = GetCurrentResourceName()

---@class REC_Utils.Shared.Events
local events = {

    client = {

        testSpawnEntity = "",

        kill = "",
    },

    server = {

        

        callbacks = {

            
        },
    },
}

shApi.Functions:generateEventsName(prefix, events)

return events