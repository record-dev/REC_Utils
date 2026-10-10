
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
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

---[[
---     Convert the common options to a qb-target parameters table
---     qb-target keys the options by label and expects { options = {}, distance = n }
---]]
---@param options REC_Utils.Client.Modules.Target.TargetOptionsConfig
---@return { options: table[], distance: number|nil, }
local function toParameters(options)
    return {
        options = {
            {
                label = options.label,
                icon = options.icon or "fa-regular fa-circle-question",
                type = "client",
                event = options.clientEvent,
                canInteract = options.onCanInteract,
                action = options.onSelect,
            },
        },
        distance = options.distance,
    }
end

function QB_TARGET:addModel(model, options)

    if options.label == nil then
        print("^1failed to add qb-target model option, label is nil...^0")
        return false
    end

    qb_target:AddTargetModel(model, toParameters(options))

    return true
end

function QB_TARGET:removeModel(model)

    qb_target:RemoveTargetModel(model)

    return true
end

function QB_TARGET:addLocalEntity(entity, options)

    if options.label == nil then
        print("^1failed to add qb-target entity option, label is nil...^0")
        return false
    end

    qb_target:AddTargetEntity(entity, toParameters(options))

    return true
end

function QB_TARGET:removeLocalEntity(entity)

    qb_target:RemoveTargetEntity(entity)

    return true
end


return QB_TARGET