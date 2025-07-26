local loadingScreenFinished = false
local ready = false
local guiEnabled = false
local timecycleModifier = "hud_def_blur"
local ESX = exports["es_extended"]:getSharedObject()

ESX.SecureNetEvent("esx_identity:alreadyRegistered", function()
    SendNUIMessage({
        action = "enableui",
        data = {
            visible = false
        }
    })
    SetNuiFocus(false, false)
end)

ESX.SecureNetEvent("esx_identity:setPlayerData", function(data)
    SendNUIMessage({
        action = "setPlayerData",
        data = data
    })
end)

AddEventHandler("esx:loadingScreenOff", function()
    loadingScreenFinished = true
end)

RegisterNUICallback("ready", function(_, cb)
    cb({})
end)

function setGuiState(state)
    SetNuiFocus(state, state)
    guiEnabled = state

    if state then
        SetTimecycleModifier(timecycleModifier)
    else
        ClearTimecycleModifier()
    end

    SendNUIMessage({
        action = "enableui",
        data = {
            visible = state
        }
    })
end

RegisterNetEvent("esx_identity:showRegisterIdentity", function()
    SendNUIMessage({
        action = "enableui",
        data = {
            visible = true
        }
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("register", function(data, cb)

     data.sex = string.lower(data.sex)
    
    ESX.TriggerServerCallback("esx_identity:registerIdentity", function(success, errorMsg)
        if success then
            SendNUIMessage({
                action = "enableui",
                data = {
                    visible = false
                }
            })
            SetNuiFocus(false, false)
            ESX.ShowNotification("Registration successful!")
        else
            ESX.ShowNotification(errorMsg or "Registration failed")
        end
        
        cb({ success = success, error = errorMsg })
    end, data)
end)

RegisterNetEvent("esx_identity:setPlayerData", function(data)
    if data then
        local state = Player(source).state
        state:set("name", ("%s %s"):format(data.firstName, data.lastName), true)
        state:set("firstName", data.firstName, true)
        state:set("lastName", data.lastName, true)
        state:set("dateofbirth", data.dateOfBirth, true)
        state:set("sex", data.sex, true)
        state:set("height", data.height, true)
    end
end)
