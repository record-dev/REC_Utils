
---@type REC_Library.Shared.API
local shApi = require "@REC_Library.shared.sh_api"
local apiShCfg = shApi.Config
local bankType = apiShCfg.bank

local apiShEnums = shApi.Enums
local bankTypes = apiShEnums.BankTypes

if bankType ~= bankTypes.esx then
    return
end

---@type REC_Utils.Server.Modules.Bank
---@diagnostic disable-next-line: missing-fields
local ESX_BANKING = {}

function ESX_BANKING:getAccount(society)
    local p = promise.new()

    ---@param data? { account: integer, }
    TriggerEvent("esx_society:getSociety", society, function(data)
        if data == nil then
            p:resolve(0)
            return
        end

        TriggerEvent("esx_addonaccount:getSharedAccount", data.account, function(account)
            if account == nil then
                p:resolve(0)
                return
            end

            p:resolve(account.money or 0)
        end)
    end)

    return {
        money = Citizen.Await(p),
    }
end

return ESX_BANKING
