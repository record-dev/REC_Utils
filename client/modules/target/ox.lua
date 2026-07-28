
---@type REC_Library.Client.API, REC_Library.Shared.API
local clApi, shApi = require "@REC_Library.client.cl_api", require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local target = apiShCfg.target

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.TargetTypes

if target ~= medicalTypes.ox then
    return
end

---@type REC_Utils.Client.Modules.Target
---@diagnostic disable-next-line: missing-fields
local OX_TARGET = {}

local ox_target = exports.ox_target

function OX_TARGET:addModel(model, options)

    local newOptions = clApi.Class.Target.Ox.OxTargetConfigBuilder:new(options.label)
        :setDistance(options.distance)
        :setEvent(options.clientEvent)
        :setIcon(options.icon)
        :setIconColor(options.iconColor)
        :setOnSelect(options.onSelect)
        :build()

    ox_target:addModel(model, { newOptions, })

    return true
end

function OX_TARGET:removeModel(model)

    ox_target:removeModel(model)

    return true
end

function OX_TARGET:addLocalEntity(entity, options)

    local newOptions = clApi.Class.Target.Ox.OxTargetConfigBuilder:new(options.label)
        :setDistance(options.distance)
        :setEvent(options.clientEvent)
        :setIcon(options.icon)
        :setIconColor(options.iconColor)
        :setOnSelect(options.onSelect)
        :build()

    ox_target:addLocalEntity(entity, { newOptions, })

    return true
end

function OX_TARGET:removeLocalEntity(entity)

    ox_target:removeLocalEntity(entity)

    return true
end


return OX_TARGET