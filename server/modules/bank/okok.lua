
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
    local account = okok_Banking:GetAccount(society)

    -- okokBanking returns the balance itself
    if type(account) == "number" then
        return {
            money = account,
        }
    end

    if type(account) ~= "table" then
        return {
            money = 0,
        }
    end

    return {
        money = account.value or account.money or 0,
    }
end

return OKOK_BANKING
