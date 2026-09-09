
---[[
---     Discord Components V2 message builder
---
---     Builds the components array of a message sent with the IS_COMPONENTS_V2 flag.
---     Text is markdown, a container groups what it holds behind one accent bar,
---     and every text display of the whole message shares a 4000 character budget.
---     https://discord.com/developers/docs/components/reference
---]]

---@class REC_Utils.Server.Modules.WebHook.ComponentsBuilder
---@field components table[]
local ComponentsBuilder = {}
ComponentsBuilder.__index = ComponentsBuilder

---@enum REC_Utils.Server.Modules.WebHook.ComponentTypes
local componentTypes = {
    section      = 9,
    text         = 10,
    thumbnail    = 11,
    mediaGallery = 12,
    file         = 13,
    separator    = 14,
    container    = 17,
}

---@enum REC_Utils.Server.Modules.WebHook.SeparatorSpacing
local separatorSpacings = {
    small = 1,
    large = 2,
}

---instantiation
---@return self
function ComponentsBuilder:new()
    local instance = setmetatable({}, self)
    instance.components = {}
    return instance
end

---@param value REC_Utils.Server.Modules.WebHook.ComponentsBuilder|table[]
---@return table[]
local function toComponents(value)

    if type(value) == "table" and type(value.build) == "function" then
        return value:build()
    end

    assert(type(value) == "table", "components must be a builder or an array")

    return value
end

---[[
---     Markdown text
---]]
---@param content string
---@return self
function ComponentsBuilder:addText(content)

    assert(type(content) == "string", "content must be a string")

    self.components[#self.components+1] = {
        type    = componentTypes.text,
        content = content,
    }

    return self
end

---[[
---     A gap, with a line across it unless divider is false
---]]
---@param divider? boolean default true
---@param spacing? "small" | "large" default small
---@return self
function ComponentsBuilder:addSeparator(divider, spacing)

    self.components[#self.components+1] = {
        type    = componentTypes.separator,
        divider = divider ~= false,
        spacing = separatorSpacings[spacing] or separatorSpacings.small,
    }

    return self
end

---[[
---     Up to three text displays with a thumbnail on the right
---]]
---@param contents string[]
---@param thumbnailUrl string
---@return self
function ComponentsBuilder:addSection(contents, thumbnailUrl)

    assert(type(contents) == "table" and #contents >= 1 and #contents <= 3, "contents must hold 1 to 3 strings")
    assert(type(thumbnailUrl) == "string", "thumbnailUrl must be a string")

    ---@type table[]
    local texts = {}
    for index, content in ipairs(contents) do
        texts[index] = { type = componentTypes.text, content = content, }
    end

    self.components[#self.components+1] = {
        type       = componentTypes.section,
        components = texts,
        accessory  = {
            type  = componentTypes.thumbnail,
            media = { url = thumbnailUrl, },
        },
    }

    return self
end

---[[
---     One to ten images shown as a grid
---]]
---@param urls string[]
---@return self
function ComponentsBuilder:addMediaGallery(urls)

    assert(type(urls) == "table" and #urls >= 1 and #urls <= 10, "urls must hold 1 to 10 strings")

    ---@type table[]
    local items = {}
    for index, url in ipairs(urls) do
        items[index] = { media = { url = url, }, }
    end

    self.components[#self.components+1] = {
        type  = componentTypes.mediaGallery,
        items = items,
    }

    return self
end

---[[
---     A box with an accent bar on the left, holding the components of another builder
---]]
---@param inner REC_Utils.Server.Modules.WebHook.ComponentsBuilder|table[]
---@param accentColor? integer 0xRRGGBB, no bar when omitted
---@param spoiler? boolean
---@return self
function ComponentsBuilder:addContainer(inner, accentColor, spoiler)

    if accentColor ~= nil then
        assert(type(accentColor) == "number", "accentColor must be a number")
    end

    self.components[#self.components+1] = {
        type         = componentTypes.container,
        accent_color = accentColor,
        spoiler      = spoiler == true or nil,
        components   = toComponents(inner),
    }

    return self
end

---@return table[]
function ComponentsBuilder:build()
    return self.components
end

return ComponentsBuilder
