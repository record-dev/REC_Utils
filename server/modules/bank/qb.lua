
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local bankType = apiShCfg.bank

local apiShEnums = shApi.Enums
local bankTypes = apiShEnums.BankTypes

if bankType ~= bankTypes.qb then
    return
end

local qb_Banking = exports["qb-banking"]

---@type REC_Utils.Server.Modules.Bank
---@diagnostic disable-next-line: missing-fields
local QB_BANKING = {}

function QB_BANKING:getAccount(society)
    return qb_Banking:GetAccountBalance(society)
end

return QB_BANKING