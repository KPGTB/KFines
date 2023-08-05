function RegisterUsableItem(item, func)
    QBCore.Functions.CreateUseableItem(item, func)
end

function RegisterServerCallback(name, func)
    QBCore.Functions.CreateCallback(name,func)
end

function GetPlayerFromId(id)
    return QBCore.Functions.GetPlayer(tonumber(id))
end

function GetPlayerFromIdentifier(citizenId)
    return QBCore.Functions.GetPlayerByCitizenId(identifier)
end

function GetJob(id)
    local xPlayer = GetPlayerFromId(tonumber(id))
    return xPlayer.PlayerData.job.name
end

function GetIdentifiter(id)
    local xPlayer = GetPlayerFromId(tonumber(id))
    return xPlayer.PlayerData.citizenid
end

function ShowNotification(id, text)
    TriggerClientEvent('QBCore:Notify',tonumber(id), text)
end

function GetSourceFromIdentifier(identifier)
    return GetPlayerFromIdentifier(identifier).PlayerData.source
end

function IsOnline(identifier)
    return GetPlayerFromIdentifier(identifier) ~= nil
end

function RemoveMoney(identifier, account, money)
    xPlayer = GetPlayerFromIdentifier(identifier)
    
    if xPlayer ~= nil then
        xPlayer.Functions.RemoveMoney(account, money)
    else
        MySQL.Async.fetchAll('SELECT money FROM players WHERE citizenid = @identifier', {identifier = identifier }, function(result)
            if result[1] ~= nil then
                local accounts = json.decode(result[1].money)
                accounts.bank = accounts.bank - fine
                MySQL.Async.execute("UPDATE players SET money = @accounts WHERE citizenid = @identifier",
                    {
                    identifier = identifier,
                    accounts = json.encode(accounts)
                    }
                )
            end
        end)
    end
end

function AddSocietyMoney(society, money)
    exports['qb-management']:AddMoney(society:gsub("society_", ""), money)
end

function GetIdentifierFromData(name, surname, dob, sex)
    local _sex = sex
    if _sex == "m" then
        _sex = 0
    else
        _sex = 1
    end

    local result = MySQL.Sync.fetchAll("SELECT * FROM players")
    local citizenId = nil

    if result == nil then
        return nil
    end

    for _,v in pairs(result) do
        local charInfo = json.decode(v.charinfo)
        if charInfo.firstname == name and charInfo.lastname == surname and charInfo.birthdate == dob and charInfo.gender == _sex then
            citizenId = v.citizenid
            break
        end
    end
	return citizenId
end