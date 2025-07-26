local db = require 'server.db'
local utils = require 'server.functions'

local playerIdentity = {}
local alreadyRegistered = {}
local multichar = ESX.GetConfig().Multichar

local function saveDescription(identifier, description)
    if not identifier or not description then return end
    MySQL.update.await("UPDATE users SET description = ? WHERE identifier = ?", {description, identifier})
end

RegisterNetEvent('esx_identity:updateDescription', function(description)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    saveDescription(xPlayer.identifier, description)
end)

function SetPlayerData(xPlayer, data)
    local name = ("%s %s"):format(data.firstName, data.lastName)
    xPlayer.setName(name)
    xPlayer.set("firstName", data.firstName)
    xPlayer.set("lastName", data.lastName)
    xPlayer.set("dateofbirth", data.dateOfBirth)
    xPlayer.set("sex", data.sex)
    xPlayer.set("height", data.height)

    local state = Player(xPlayer.source).state
    state:set("name", name, true)
    state:set("firstName", data.firstName, true)
    state:set("lastName", data.lastName, true)
    state:set("dateofbirth", data.dateOfBirth, true)
    state:set("sex", data.sex, true)
    state:set("height", data.height, true)
end

local function setIdentity(xPlayer)
    if not alreadyRegistered[xPlayer.identifier] then
        return
    end
    local currentIdentity = playerIdentity[xPlayer.identifier]
    SetPlayerData(xPlayer, currentIdentity)

    TriggerClientEvent("esx_identity:setPlayerData", xPlayer.source, currentIdentity)
    if currentIdentity.saveToDatabase then
        db.saveIdentity(xPlayer.identifier, currentIdentity)
    end

    playerIdentity[xPlayer.identifier] = nil
end

local function checkIdentity(xPlayer)
    db.loadIdentity(xPlayer.identifier, function(result)
        if not result then
            return TriggerClientEvent("esx_identity:showRegisterIdentity", xPlayer.source)
        end

        playerIdentity[xPlayer.identifier] = result
        alreadyRegistered[xPlayer.identifier] = true
        setIdentity(xPlayer)
    end)
end

if not multichar then
    AddEventHandler("playerConnecting", function(_, _, deferrals)
        deferrals.defer()
        local _, identifier = source, ESX.GetIdentifier(source)
        Wait(40)

        if not identifier then
            return deferrals.done(TranslateCap("no_identifier"))
        end

        db.loadIdentity(identifier, function(result)
            if not result then
                playerIdentity[identifier] = nil
                alreadyRegistered[identifier] = false
                return deferrals.done()
            end

            playerIdentity[identifier] = result
            alreadyRegistered[identifier] = true
            deferrals.done()
        end)
    end)

    AddEventHandler("onResourceStart", function(resource)
        if resource ~= GetCurrentResourceName() then
            return
        end
        Wait(300)

        while not ESX do
            Wait(0)
        end

        local xPlayers = ESX.GetExtendedPlayers()
        for i = 1, #xPlayers do
            if xPlayers[i] then
                checkIdentity(xPlayers[i])
            end
        end
    end)

    RegisterNetEvent("esx:playerLoaded", function(playerId, xPlayer)
        local currentIdentity = playerIdentity[xPlayer.identifier]

        if currentIdentity and alreadyRegistered[xPlayer.identifier] then
            SetPlayerData(xPlayer, currentIdentity)
            TriggerClientEvent("esx_identity:setPlayerData", xPlayer.source, currentIdentity)
            if currentIdentity.saveToDatabase then
                db.saveIdentity(xPlayer.identifier, currentIdentity)
            end
            Wait(0)
            TriggerClientEvent("esx_identity:alreadyRegistered", xPlayer.source)
            playerIdentity[xPlayer.identifier] = nil
        else
            TriggerClientEvent("esx_identity:showRegisterIdentity", xPlayer.source)
        end
    end)
end

ESX.RegisterServerCallback("esx_identity:registerIdentity", function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local registrationData = {
        firstname = data.firstName,
        lastname = data.lastName,
        dateofbirth = data.dateOfBirth,
        sex = data.sex,
        height = data.height
    }

    -- Validation checks
    if not utils.checkName(registrationData.firstname) then
        TriggerClientEvent("esx:showNotification", source, TranslateCap("invalid_firstname_format"), "error")
        return cb(false)
    end
    if not utils.checkName(registrationData.lastname) then
        TriggerClientEvent("esx:showNotification", source, TranslateCap("invalid_lastname_format"), "error")
        return cb(false)
    end
    if not utils.checkSex(registrationData.sex) then
        TriggerClientEvent("esx:showNotification", source, TranslateCap("invalid_sex_format"), "error")
        return cb(false)
    end
    if not utils.checkDOB(registrationData.dateofbirth) then
        TriggerClientEvent("esx:showNotification", source, TranslateCap("invalid_dob_format"), "error")
        return cb(false)
    end
    if not utils.checkHeight(registrationData.height) then
        TriggerClientEvent("esx:showNotification", source, TranslateCap("invalid_height_format"), "error")
        return cb(false)
    end

    if xPlayer then
        if alreadyRegistered[xPlayer.identifier] then
            xPlayer.showNotification(TranslateCap("already_registered"), "error")
            return cb(false)
        end

        playerIdentity[xPlayer.identifier] = {
            firstName = utils.formatName(registrationData.firstname),
            lastName = utils.formatName(registrationData.lastname),
            dateOfBirth = registrationData.dateofbirth,
            sex = registrationData.sex,
            height = registrationData.height
        }

        local currentIdentity = playerIdentity[xPlayer.identifier]
        SetPlayerData(xPlayer, currentIdentity)
        TriggerClientEvent("esx_identity:setPlayerData", xPlayer.source, currentIdentity)
        
        alreadyRegistered[xPlayer.identifier] = true
        playerIdentity[xPlayer.identifier] = nil
        return cb(true)
    end

    if not multichar then
        TriggerClientEvent("esx:showNotification", source, TranslateCap("data_incorrect"), "error")
        return cb(false)
    end

    local Identity = {
        firstName = utils.formatName(registrationData.firstname),
        lastName = utils.formatName(registrationData.lastname),
        dateOfBirth = registrationData.dateofbirth,
        sex = registrationData.sex,
        height = registrationData.height
    }

    TriggerEvent("esx_identity:completedRegistration", source, registrationData)
    TriggerClientEvent("esx_identity:setPlayerData", source, Identity)
    cb(true)
end)

ESX.RegisterServerCallback("esx_identity:getDescription", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return cb(nil) end
    
    MySQL.single("SELECT description FROM users WHERE identifier = ?", {xPlayer.identifier}, function(result)
        cb(result and result.description or "")
    end)
end)
