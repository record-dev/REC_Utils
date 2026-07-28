
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local bankType = apiShCfg.bank

local apiShEnums = shApi.Enums
local bankTypes = apiShEnums.BankTypes

local renewed_Banking = exports["Renewed-Banking"]

if bankType ~= bankTypes.renewed then
    return
end

---@type REC_Utils.Server.Modules.Bank
---@diagnostic disable-next-line: missing-fields
local RENEWED_BANKING = {}

function RENEWED_BANKING:getAccount(society)
    return {
        money = renewed_Banking:getAccountMoney(society) or 0,
    }
end

return RENEWED_BANKING