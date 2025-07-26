local function checkDOBFormat(str)
    if not str or type(str) ~= "string" then 
        return false 
    end
    
    local year, month, day = str:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
    if not year or not month or not day then 
        return false 
    end
    
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)
    
    if year < Config.LowestYear or year > Config.HighestYear then 
        return false 
    end
    if month < 1 or month > 12 then 
        return false 
    end
    if day < 1 or day > 31 then 
        return false 
    end
    
    return true
end

local function checkAlphanumeric(str)
    return (string.match(str, "%W"))
end

local function checkForNumbers(str)
    return (string.match(str, "%d"))
end

local function checkNameFormat(name)
    if not checkAlphanumeric(name) and not checkForNumbers(name) then
        local stringLength = string.len(name)
        return stringLength > 0 and stringLength < Config.MaxNameLength
    end
    return false
end

local function checkSexFormat(sex)
    if not sex then
        return false
    end
    return sex == "m" or sex == "M" or sex == "f" or sex == "F"
end

local function checkHeightFormat(height)
    local numHeight = tonumber(height) or 0
    return numHeight >= Config.MinHeight and numHeight <= Config.MaxHeight
end

local function convertToLowerCase(str)
    return string.lower(str)
end

local function convertFirstLetterToUpper(str)
    return str:gsub("^%l", string.upper)
end

local function formatName(name)
    local loweredName = convertToLowerCase(name)
    return convertFirstLetterToUpper(loweredName)
end

return {
    checkDOB = checkDOBFormat,
    checkName = checkNameFormat,
    checkSex = checkSexFormat,
    checkHeight = checkHeightFormat,
    formatName = formatName
}
