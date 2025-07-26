Camera = {}
Camera._index = Camera
Camera.cam = nil

function Camera:Setup()
    self.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(self.cam, true)
    RenderScriptCams(true, false, 1, true, true)

    local playerPed = PlayerPedId()
    local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0, 1.7, 0.4)
    local spawnCoords = Multicharacter.spawnCoords

    SetCamCoord(self.cam, offset.x, offset.y, offset.z)
    PointCamAtCoord(self.cam, spawnCoords.x, spawnCoords.y, spawnCoords.z + 1.3)
end

function Camera:Destroy()
    if self.cam then
        SetCamActive(self.cam, false)
        RenderScriptCams(false, false, 0, true, true)
        self.cam = nil
    end
end

-- Export the Camera module
_G.Camera = Camera
