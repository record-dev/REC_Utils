
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local bankType = apiShCfg.bank

local apiShEnums = shApi.Enums
local bankTypes = apiShEnums.BankTypes

if bankType ~= bankTypes.okok then
    return
end

local okok_Banking = exports.okokBanking

---@type REC_Utils.Server.Modules.Bank
---@diagnostic disable-next-line: missing-fields
local OKOK_BANKING = {}

function OKOK_BANKING:getAccount(society)
    local acount = okok_Banking:GetAccount(society)
    return {
        money = acount.value or acount.money or 0,
    }
end

return OKOK_BANKING