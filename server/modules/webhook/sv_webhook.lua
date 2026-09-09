
---@class REC_Utils.Server.Modules.WebHook.WebHook
---@field url string
---@field userName string
---@field avatarUrl? string
local WebHook = {}
WebHook.__index = WebHook

---instantiation
---@param url string
---@param userName string
---@param avatarUrl? string
---@return self
function WebHook:new(url, userName, avatarUrl)
    if url == nil or type(url) ~= "string" then
        error("有効な Discord Webhook URL を渡してください", 2)
    end
    if userName == nil or type(userName) ~= "string" then
        error("有効な Discord Webhook User Name を渡してください", 2)
    end
    if avatarUrl ~= nil then
        if type(url) ~= "string" then
            error("有効な Discord Avatar URL を渡してください", 2)
        end
    end

    local instance = setmetatable({}, self)
    instance.url = url
    instance.userName = userName
    instance.avatarUrl = avatarUrl
    return instance
end

---Simple text sending
---@param content string|integer|table
---@return boolean
function WebHook:send(content)
    if content == nil or content == "" then
        return false
    end

    content = (function ()
        if type(content) == "number" then
            return tostring(content)
        elseif type(content) == "table" then
            return json.encode(content, { indent = true })
        else
            return content
        end
    end)()

    local payload = {
        content = content,
        username = self.userName,
        avatar_url = self.avatarUrl,
    }

    return self:_send(payload, { indent = true })
end

---Send in Embed format
---@param embedData REC_Utils.Server.Modules.WebHook.EmbedOptions
---@return boolean
function WebHook:sendEmbed(embedData)
    if not embedData or type(embedData) ~= "table" then
        return false
    end

    -- Automatically determine whether embedData is an array format (multiple embeds) or a single object
    local embeds = {}
    if embedData[1] and type(embedData[1]) == "table" then
        embeds = embedData
    else
        embeds = { embedData }
    end

    local payload = {
        username = self.userName,
        avatar_url = self.avatarUrl,
        embeds = embeds,
    }

    return self:_send(payload)
end

---[[
---     Send a Components V2 message (IS_COMPONENTS_V2 flag, no content and no embeds)
---     A webhook needs ?with_components=true on its URL for Discord to accept components.
---]]
---@param components REC_Utils.Server.Modules.WebHook.ComponentsBuilder|table[]
---@return boolean
function WebHook:sendComponents(components)

    if type(components) == "table" and type(components.build) == "function" then
        components = components:build()
    end

    if type(components) ~= "table" or #components == 0 then
        return false
    end

    return self:_send({
        username   = self.userName,
        avatar_url = self.avatarUrl,
        flags      = 32768,
        components = components,
    })
end

---@private
---@param options REC_Utils.Server.Modules.WebHook.WebHook.WebhookOptions
---@return boolean
function WebHook:_send(options, ...)
    options = options or {}

    local payload = {
        content     = options.content or nil,
        username    = options.username or "REC_Utils",
        avatar_url  = options.avatar_url or nil,
        tts         = options.tts or false,
        embeds      = options.embeds or nil,
        flags       = options.flags or nil,
        components  = options.components or nil,
    }

    -- components ride on a query flag, everything else on the bare url
    local url = self.url
    if options.components ~= nil then
        url = url .. (url:find("?", 1, true) ~= nil and "&" or "?") .. "with_components=true"
    end

    -- discard nil items
    for k, v in pairs(payload) do
        if v == nil then
            payload[k] = nil
        end
    end

    PerformHttpRequest(url, function(err, text, headers)
        if err == 200 or err == 204 then
            -- Success (204 No Content is normal)
        else
            print("^1[REC_Utils] Webhook Error: " .. tostring(err) .. " | Response: " .. tostring(text) .. "^7")
            print("^1URL: " .. self.url:sub(1, 60) .. "...^7")
        end
    end, 'POST', json.encode(payload, ...), { ['Content-Type'] = 'application/json' })

    return true
end

---@class REC_Utils.Server.Modules.WebHook.WebHook.WebhookOptions
---@field content? string
---@field username? string
---@field avatar_url? string
---@field tts? boolean
---@field embeds? REC_Utils.Server.Modules.WebHook.EmbedOptions[]
---@field flags? integer
---@field components? table[]

return WebHook
