
---@class REC_Utils.Client.Modules.Raycast
---@field result REC_Utils.Client.Modules.Raycast.Result
---@field drawBoundingBox boolean
---@field isActive boolean
local Raycast = {}

local LINE_COLOR = { r = 194, g = 241, b = 243, a = 255 }
local BOX_COLOR  = { r = 0, g = 255, b = 0, a = 255 }

---@diagnostic disable-next-line: missing-fields
Raycast.result = {}
Raycast.drawBoundingBox = true
Raycast.isActive = false

---Helper function used internally: Calculate forward coordinates from camera
---@param distance number
local function getCoordsFromCam(distance)
    local camRot = GetGameplayCamRot(2)
    local camPos = GetGameplayCamCoord()

    local forward = vector3(
        -math.sin(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
        math.cos(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
        math.sin(math.rad(camRot.x))
    )

    local farAway = camPos + forward * distance

    return camPos, farAway
end

local function drawRotatedBoundingBox(entity, color)
    if not entity or entity == 0 or DoesEntityExist(entity) == false then
        return
    end

    local model = GetEntityModel(entity)
    if model == 0 then return end

    local min, max = GetModelDimensions(model)
    local pos = GetEntityCoords(entity, false)
    local rot = GetEntityRotation(entity, 2)   -- rotationOrder = 2 (recommended)

    -- 8 local vertices (min/max combination)
    local localVertices = {
        vector3(min.x, min.y, min.z),   -- 0
        vector3(max.x, min.y, min.z),   -- 1
        vector3(max.x, max.y, min.z),   -- 2
        vector3(min.x, max.y, min.z),   -- 3
        vector3(min.x, min.y, max.z),   -- 4
        vector3(max.x, min.y, max.z),   -- 5
        vector3(max.x, max.y, max.z),   -- 6
        vector3(min.x, max.y, max.z),   -- 7
    }

    -- Apply rotation + position
    local function ToWorld(point)
        local radX = math.rad(rot.x)
        local radY = math.rad(rot.y)
        local radZ = math.rad(rot.z)   -- heading mainly affects the Z axis

        -- Z-axis rotation (heading)
        local x = point.x * math.cos(radZ) - point.y * math.sin(radZ)
        local y = point.x * math.sin(radZ) + point.y * math.cos(radZ)
        local z = point.z

        -- X-axis rotation (pitch)
        local xx = x
        local yy = y * math.cos(radX) - z * math.sin(radX)
        local zz = y * math.sin(radX) + z * math.cos(radX)

        -- Y-axis rotation (roll) *It has little effect on many entities, but
        local finalX = xx * math.cos(radY) + zz * math.sin(radY)
        local finalY = yy
        local finalZ = -xx * math.sin(radY) + zz * math.cos(radY)

        return vector3(
            pos.x + finalX,
            pos.y + finalY,
            pos.z + finalZ
        )
    end

    -- Calculate 8 world coordinates
    local v = {}
    for i = 1, 8 do
        v[i] = ToWorld(localVertices[i])
    end

    local r, g, b, a = color.r, color.g, color.b, color.a

    -- Draw 12 lines (edges of cube)
    -- Bottom
    DrawLine(v[1].x, v[1].y, v[1].z, v[2].x, v[2].y, v[2].z, r,g,b,a)
    DrawLine(v[2].x, v[2].y, v[2].z, v[3].x, v[3].y, v[3].z, r,g,b,a)
    DrawLine(v[3].x, v[3].y, v[3].z, v[4].x, v[4].y, v[4].z, r,g,b,a)
    DrawLine(v[4].x, v[4].y, v[4].z, v[1].x, v[1].y, v[1].z, r,g,b,a)

    --Top surface
    DrawLine(v[5].x, v[5].y, v[5].z, v[6].x, v[6].y, v[6].z, r,g,b,a)
    DrawLine(v[6].x, v[6].y, v[6].z, v[7].x, v[7].y, v[7].z, r,g,b,a)
    DrawLine(v[7].x, v[7].y, v[7].z, v[8].x, v[8].y, v[8].z, r,g,b,a)
    DrawLine(v[8].x, v[8].y, v[8].z, v[5].x, v[5].y, v[5].z, r,g,b,a)

    -- Side (vertical line)
    DrawLine(v[1].x, v[1].y, v[1].z, v[5].x, v[5].y, v[5].z, r,g,b,a)
    DrawLine(v[2].x, v[2].y, v[2].z, v[6].x, v[6].y, v[6].z, r,g,b,a)
    DrawLine(v[3].x, v[3].y, v[3].z, v[7].x, v[7].y, v[7].z, r,g,b,a)
    DrawLine(v[4].x, v[4].y, v[4].z, v[8].x, v[8].y, v[8].z, r,g,b,a)
end

---Raycast execution (1 frame)
local function performRaycastAndDraw()
    local startCoords, endCoords = getCoordsFromCam(1000.0)  -- Up to 300m away

    local rayHandle = StartShapeTestRay(
        startCoords.x, startCoords.y, startCoords.z,
        endCoords.x,   endCoords.y,   endCoords.z,
        -1, PlayerPedId(), 7
    )

    local _, hit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local selfCoords = GetEntityCoords(cache.ped)
    DrawLine(selfCoords.x, selfCoords.y, selfCoords.z, hitCoords.x, hitCoords.y, hitCoords.z, LINE_COLOR.r, LINE_COLOR.g, LINE_COLOR.b, LINE_COLOR.a)

    if hit and entityHit ~= 0 and (IsEntityAVehicle(entityHit) or IsEntityAPed(entityHit) or IsEntityAnObject(entityHit)) then
        Raycast.result = {
            hit       = true,
            endCoords = hitCoords,
            normal    = surfaceNormal,
            entity    = entityHit or 0
        }

        if Raycast.drawBoundingBox == true then
            if entityHit and entityHit ~= 0 and DoesEntityExist(entityHit) then
                drawRotatedBoundingBox(entityHit, BOX_COLOR)
            end
        end

    else
        Raycast.result = {
            hit       = false,
            endCoords = hitCoords or endCoords,
            normal    = surfaceNormal or vector3(0,0,0),
            entity    = 0
        }
    end
end

---Raycast switching
---@param active boolean?
---@return boolean
function Raycast:toggle(active)
    if active ~= nil then
        self.isActive = active
    else
        self.isActive = not self.isActive
    end

    Citizen.CreateThread(function (threadId)
        while self.isActive == true do
            Citizen.Wait(0)
            performRaycastAndDraw()
            -- print(json.encode(self:getResult(), { indent = true, }))
        end
    end)

    return true
end

---@return REC_Utils.Client.Modules.Raycast.Result
function Raycast:getResult()
    return self.result
end

---@param drawBoundingBox boolean|nil
---@return self
function Raycast:setDrawBoundingBox(drawBoundingBox)
    if drawBoundingBox == nil then return self end
    self.drawBoundingBox = drawBoundingBox
    return self
end

return Raycast

---@class REC_Utils.Client.Modules.Raycast.Result
---@field hit boolean
---@field endCoords vector3
---@field normal vector3
---@field entity integer
