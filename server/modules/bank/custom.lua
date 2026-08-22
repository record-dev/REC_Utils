
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local bankType = apiShCfg.bank

local apiShEnums = shApi.Enums
local bankTypes = apiShEnums.BankTypes

if bankType ~= bankTypes.custom then
    return
end

---@type REC_Utils.Server.Modules.Bank
---@diagnostic disable-next-line: missing-fields
local CUSTOM_BANKING = {}

function CUSTOM_BANKING:getAccount(society)

    -- 利用側が .money を見るので形だけ揃える
    return {
        money = 0,
    }
end

return CUSTOM_BANKING