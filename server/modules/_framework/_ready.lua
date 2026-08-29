---[[
---     Framework readiness
---     Nothing orders the start of one resource against another: with a plain ensure
---     list REC_* can come up before qbx_core. Every adapter reaches its framework
---     through exports, which fail while that resource is still stopped, so callers
---     need to be able to ask whether it is up, or wait for it.
---]]

---@param resourceName string|nil nil when the framework is not a resource we can name
---@return fun(self: any): string|nil getResourceName
---@return fun(self: any): boolean isReady
---@return fun(self: any, timeoutMs?: integer): boolean waitUntilReady
return function (resourceName)

    ---@return string|nil
    local function getResourceName()
        return resourceName
    end

    ---@return boolean
    local function isReady()

        -- a framework we cannot name cannot be waited on, so it is treated as up
        if resourceName == nil then
            return true
        end

        return GetResourceState(resourceName) == "started"
    end

    ---[[
    ---     Blocks the calling thread until the framework is up
    ---     Returns false on timeout rather than waiting forever, so a misconfigured
    ---     framework name surfaces as a failure instead of a resource that never boots.
    ---]]
    ---@param timeoutMs? integer defaults to 60 seconds
    ---@return boolean
    local function waitUntilReady(_, timeoutMs)

        if isReady() == true then
            return true
        end

        local deadline = GetGameTimer() + (timeoutMs or 60000)

        while GetGameTimer() < deadline do
            Wait(100)
            if isReady() == true then
                return true
            end
        end

        return false
    end

    return getResourceName, isReady, waitUntilReady
end
