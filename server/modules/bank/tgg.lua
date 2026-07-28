
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local bankType = apiShCfg.bank

local apiShEnums = shApi.Enums
local bankTypes = apiShEnums.BankTypes

if bankType ~= bankTypes.tgg then
    return
end

local tgg_Banking = exports["tgg-banking"]

---@type REC_Utils.Server.Modules.Bank
---@diagnostic disable-next-line: missing-fields
local TGG_BANKING = {}

function TGG_BANKING:getAccount(society)
    return tgg_Banking:GetSocietyAccountMoney(society)
end

return TGG_BANKING