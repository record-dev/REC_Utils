
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local target = apiShCfg.target

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.TargetTypes

if target ~= medicalTypes.custom then
    return
end

---@type REC_Utils.Client.Modules.Target
---@diagnostic disable-next-line: missing-fields
local CUSTOM_TARGET = {}


function CUSTOM_TARGET:addModel(model, options)

    

    return true
end

function CUSTOM_TARGET:removeModel(model)

    

    return true
end

function CUSTOM_TARGET:addLocalEntity(entity, options)

    

    return true
end

function CUSTOM_TARGET:removeLocalEntity(entity)



    return true
end


return CUSTOM_TARGET