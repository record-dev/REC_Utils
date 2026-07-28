
---@class REC_Utils.Server.Modules.WebHook.EmbedOptions
---@field title? string
---@field description? string
---@field color integer -- 0xRRGGBB format (e.g. 0xff0000)
---@field fields? REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Field[]
---@field footer? REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Footer
---@field author? REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Author
---@field image? REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Image
---@field thumbnail? REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Thumbnail
---@field timestamp? string -- ISO8601 format recommended "2026-03-30T12:00:00Z"
---@field url? string -- To link the entire Embed

---@class REC_Utils.Server.Modules.WebHook.EmbedOptionsBuilder: REC_Utils.Server.Modules.WebHook.EmbedOptions
local EmbedOptionsBuilder = {}
EmbedOptionsBuilder.__index = EmbedOptionsBuilder

---instantiation
---@return self
function EmbedOptionsBuilder:new()
    local instance = setmetatable({}, self)
    instance.color = 2424721
    return instance
end

---@param title string|nil
---@return self
function EmbedOptionsBuilder:setTitle(title)
    if title == nil then
        return self
    end
    self.title = title
    return self
end

---@param description string|nil
---@return self
function EmbedOptionsBuilder:setDescription(description)
    if description == nil then
        return self
    end
    self.description = description
    return self
end

---@param color integer|nil
---@return self
function EmbedOptionsBuilder:setColor(color)
    if color == nil then
        return self
    end
    self.color = color
    return self
end

---@param fields REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Field[]|nil
---@return self
function EmbedOptionsBuilder:setFields(fields)
    if fields == nil then
        return self
    end
    self.fields = fields
    return self
end

---@param footer REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Footer|nil
---@return self
function EmbedOptionsBuilder:setFooter(footer)
    if footer == nil then
        return self
    end
    self.footer = footer
    return self
end

---@param author REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Author|nil
---@return self
function EmbedOptionsBuilder:setAuthor(author)
    if author == nil then
        return self
    end
    self.author = author
    return self
end

---@param image REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Image|nil
---@return self
function EmbedOptionsBuilder:setImage(image)
    if image == nil then
        return self
    end
    self.image = image
    return self
end

---@param thumbnail REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Thumbnail|nil
---@return self
function EmbedOptionsBuilder:setThumbnail(thumbnail)
    if thumbnail == nil then
        return self
    end
    self.thumbnail = thumbnail
    return self
end

---@param timestamp string|nil
---@return self
function EmbedOptionsBuilder:setTimestamp(timestamp)
    if timestamp == nil then
        return self
    end
    self.timestamp = timestamp
    return self
end

---@param url string|nil
---@return self
function EmbedOptionsBuilder:setUrl(url)
    if url == nil then
        return self
    end
    self.url = url
    return self
end

---@return REC_Utils.Server.Modules.WebHook.EmbedOptions
function EmbedOptionsBuilder:build()
    local finalOptions = {}
    for k, v in pairs(self) do
        if v ~= nil and type(v) ~= "function" then
            finalOptions[k] = v
        end
    end
    return finalOptions
end

return EmbedOptionsBuilder

---@class REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Field
---@field name string
---@field value string
---@field inline? boolean

---@class REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Footer
---@field text string
---@field icon_url? string

---@class REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Author
---@field name string
---@field url? string
---@field icon_url? string

---@class REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Image
---@field url string

---@class REC_Utils.Server.Modules.WebHook.WebHook.EmbedOptionsBuilder.Thumbnail
---@field url string
