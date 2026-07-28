
---@class REC_Utils.Client.Modules.HelpText
local HelpText = {}

---Draw
---@param args string|string[]
---@param duration? integer
---@return boolean
function HelpText:draw(args, duration)

    BeginTextCommandDisplayHelp("THREESTRINGS")

    if type(args) ~= "table" then
        AddTextComponentSubstringPlayerName(args)
    else
        for _, text in ipairs(args) do
            AddTextComponentSubstringPlayerName(text)
        end
    end

    EndTextCommandDisplayHelp(0, false, true, duration or 0)

    return true
end

return HelpText
