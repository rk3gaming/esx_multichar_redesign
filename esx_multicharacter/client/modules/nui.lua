NUI = {}
NUI._index = NUI

function NUI:OpenMenu()
    SendNUIMessage({
        action = "openMenu",
        characters = Multicharacter.Characters,
        slots = Multicharacter.slots
    })
    SetNuiFocus(true, true)
end

function NUI:Close()
    SendNUIMessage({
        action = "closeMenu"
    })
    SetNuiFocus(false, false)
end

function NUI:NewCharacter()
    self:Close()
    local slot = self:GetNextSlot()

    TriggerServerEvent("esx_multicharacter:CharacterChosen", slot, true)
    TriggerEvent("esx_identity:showRegisterIdentity")

    local playerPed = PlayerPedId()
    SetPedAoBlobRendering(playerPed, false)
    SetEntityAlpha(playerPed, 0, false)

    Multicharacter:CloseUI()
end

function NUI:GetNextSlot()
    for i = 1, Multicharacter.slots do
        if not Multicharacter.Characters[i] then
            return i
        end
    end
end

function NUI:SelectCharacter()
    local Characters = Multicharacter.Characters
    local Character = next(Characters)

    if not Multicharacter.spawned then
        Multicharacter:SetupCharacter(Character)
    end

    self:OpenMenu()
end

RegisterNUICallback("menuAction", function(data, cb)
    if data.action == "select" then
        Multicharacter.tempIndex = data.value
        Multicharacter.spawned = data.value
        
        Multicharacter:ChangeExistingPed()
        
        NUI:OpenMenu()
    elseif data.action == "new" then
        NUI:NewCharacter()
    elseif data.action == "delete" then
        TriggerServerEvent("esx_multicharacter:DeleteCharacter", data.value)
        
        Wait(500)
        
        if Multicharacter.spawned == data.value then
            Multicharacter.spawned = nil
            Multicharacter.tempIndex = nil
        end
        
        TriggerServerEvent("esx_multicharacter:SetupCharacters")
    elseif data.action == "return" then
        NUI:SelectCharacter()
    end
    cb({})
end)

RegisterNUICallback("getSpawnLocations", function(_, cb)
    cb(Locations)
end)

RegisterNUICallback("spawnAtLocation", function(data, cb)
    local selectedLocation = nil
    for i, location in ipairs(Locations) do
        if location.label == data.location then
            selectedLocation = location
            break
        end
    end

    if not selectedLocation then 
        return cb({}) 
    end

    local character = Multicharacter.Characters[Multicharacter.spawned]
    if not character then
        return cb({})
    end

    if selectedLocation.label == "Last Location" then
        if character.lastLocation then
            selectedLocation.coords = character.lastLocation
        else
            selectedLocation.coords = Config.Spawn[1]
        end
    end

    if not selectedLocation.coords then 
        return cb({}) 
    end

    local characterData = {
        skin = character.skin,
        coords = selectedLocation.coords,
        id = character.id,
        firstname = character.firstname,
        lastname = character.lastname,
        job = character.job,
        job_grade = character.job_grade,
        money = character.money,
        bank = character.bank,
        sex = character.sex,
        dateofbirth = character.dateofbirth,
        lastLocation = selectedLocation.coords 
    }

    SendNUIMessage({
        action = "hideui"
    })
    SetNuiFocus(false, false)
    
    DoScreenFadeOut(500)
    Multicharacter:AwaitFadeOut()

    Multicharacter:DestoryCamera()

    TriggerServerEvent("esx_multicharacter:CharacterChosen", characterData.id, false)

    Wait(500)

    ESX.SpawnPlayer(characterData.skin, characterData.coords, function()
        ESX.PlayerData = characterData
        ESX.PlayerLoaded = true

        Multicharacter:HideHud(false)
        SetPlayerControl(ESX.playerId, true, 0)

        Multicharacter.playerPed = PlayerPedId()
        FreezeEntityPosition(Multicharacter.playerPed, false)
        SetEntityCollision(Multicharacter.playerPed, true, true)
        SetEntityVisible(Multicharacter.playerPed, true, false)

        TriggerServerEvent("esx:onPlayerSpawn")
        TriggerEvent("esx:onPlayerSpawn")
        TriggerEvent("esx:restoreLoadout")

        Multicharacter:Reset()
        DoScreenFadeIn(750)
    end)

    cb({})
end)

RegisterNUICallback("closeUI", function(_, cb)
    Multicharacter:CloseUI()
    cb({})
end)

_G.NUI = NUI
