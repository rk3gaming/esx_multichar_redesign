local function deleteIdentityFromDatabase(xPlayer)
    MySQL.query.await("UPDATE users SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ?, description = ?, skin = ? WHERE identifier = ?", 
        { nil, nil, nil, nil, nil, nil, nil, xPlayer.identifier })

    if Config.FullCharDelete then
        MySQL.update.await("UPDATE addon_account_data SET money = 0 WHERE account_name IN (?) AND owner = ?", { { "bank_savings", "caution" }, xPlayer.identifier })
        MySQL.prepare.await("UPDATE datastore_data SET data = ? WHERE name IN (?) AND owner = ?", { "'{}'", { "user_ears", "user_glasses", "user_helmet", "user_mask" }, xPlayer.identifier })
    end
end

local function saveIdentityToDatabase(identifier, identity)
    if not identifier or not identity then return false end
    
    -- Simple direct update
    local success = pcall(function()
        MySQL.update.await([[
            UPDATE users 
            SET firstname = ?, 
                lastname = ?, 
                dateofbirth = ?, 
                sex = ?, 
                height = ?
            WHERE identifier = ?
        ]], {
            identity.firstName,
            identity.lastName,
            identity.dateOfBirth,
            identity.sex,
            identity.height,
            identifier
        })
    end)
    
    return success
end

local function loadIdentityFromDatabase(identifier, cb)
    MySQL.single([[
        SELECT firstname, lastname, dateofbirth, sex, height
        FROM users 
        WHERE identifier = ?
    ]], { identifier }, function(result)
        if not result or not result.firstname then
            return cb(nil)
        end

        cb({
            firstName = result.firstname,
            lastName = result.lastname,
            dateOfBirth = result.dateofbirth,
            sex = result.sex,
            height = result.height
        })
    end)
end

return {
    deleteIdentity = deleteIdentityFromDatabase,
    saveIdentity = saveIdentityToDatabase,
    loadIdentity = loadIdentityFromDatabase
}
