
---[[
---     Support REC_Bank
---]]

---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local bankType = apiShCfg.bank

local apiShEnums = shApi.Enums
local bankTypes = apiShEnums.BankTypes

if bankType ~= bankTypes.rec then
    return
end

local recBank = exports.REC_Bank

---@type REC_Utils.Server.Modules.Bank
---@diagnostic disable-next-line: missing-fields
local REC_BANKING = {}

function REC_BANKING:getAccount(society)

    ---@type number
    local money = recBank:getAccount(society)

    return {
        money = type(money) == "number" and money or 0,
    }
end

return REC_BANKING
