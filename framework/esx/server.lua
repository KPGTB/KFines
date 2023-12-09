function RegisterUsableItem(item, func)
    ESX.RegisterUsableItem(item, func)
end

function RegisterServerCallback(name, func)
    ESX.RegisterServerCallback(name,func)
end

function GetPlayerFromId(id)
    return ESX.GetPlayerFromId(id)
end

function GetPlayerFromIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

function GetJob(id)
    xPlayer = GetPlayerFromId(id)
    return xPlayer.job.name
end

function GetIdentifiter(id)
    xPlayer = GetPlayerFromId(id)
    return xPlayer.identifier
end

function ShowNotification(id, text)
    xPlayer = GetPlayerFromId(id)
    xPlayer.showNotification(text)
end

function GetSourceFromIdentifier(identifier)
    return GetPlayerFromIdentifier(identifier).source
end

function IsOnline(identifier)
    return GetPlayerFromIdentifier(identifier) ~= nil
end

function RemoveMoney(identifier, account, money)
    xPlayer = GetPlayerFromIdentifier(identifier)
    
    if xPlayer ~= nil then
        xPlayer.removeAccountMoney(account, money)
    else
        MySQL.Async.fetchAll('SELECT accounts FROM users WHERE identifier = @identifier', {identifier = identifier }, function(result)
            if result[1] ~= nil then
                local accounts = json.decode(result[1].accounts)
                accounts.bank = accounts.bank - fine
                MySQL.Async.execute("UPDATE users SET accounts = @accounts WHERE identifier = @identifier",
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
    TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
        if account == nil then
            Citizen.Wait(100)
            AddSocietyMoney(society, money)
        else
            account.addMoney(money)
        end
    end)
end

function GetIdentifierFromData(name, dob, sex)
    local result = MySQL.Sync.fetchAll(
		"SELECT * FROM users WHERE CONCAT(firstname, ' ', lastname)=@name AND dateofbirth=@dob AND sex=@sex",
		{name = name, dob = dob, sex = sex}
	)
    if result == nil or #result == 0 then
        return nil
    end
	return result[1].identifier
end