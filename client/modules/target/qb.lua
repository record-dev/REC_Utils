
---@type REC_Library.Client.API, REC_Library.Shared.API
local clApi, shApi = require "@REC_Library.client.cl_api", require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local target = apiShCfg.target

local apiShEnums = shApi.Enums
local medicalTypes = apiShEnums.TargetTypes

if target ~= medicalTypes.qb then
    return
end

---@type REC_Utils.Client.Modules.Target
---@diagnostic disable-next-line: missing-fields
local QB_TARGET = {}

local qb_target = exports["qb-target"]

function QB_TARGET:addModel(model, options)

    qb_target:AddTargetModel(model, options)

    return true
end

function QB_TARGET:removeModel(model)

    qb_target:RemoveTargetModel(model)

    return true
end

function QB_TARGET:addLocalEntity(entity, options)

    local newOptions = clApi.Class.Target.Qb.QbTargetConfigBuilder:new(
            ("%s-%d"):format(GetInvokingResource(), entity),
            "client",
            options.label
        )
        :setEvent(options.clientEvent)
        :setIcon(options.icon)
        :setCanInteract(options.onCanInteract)
        :setAction(options.onSelect)
        :build()

    qb_target:AddTargetEntity(entity, {
        options = { newOptions, },
        distance = options.distance,
    })

    return true
end

function QB_TARGET:removeLocalEntity(entity)

    qb_target:RemoveTargetEntity(entity)

    return true
end


return QB_TARGET