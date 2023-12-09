RegisterUsableItem("traffic_tickets_block", function(source)
	job = false

	for k,v in pairs(Config.Jobs) do
		for _,v2 in pairs(v.allowedJobs) do
			if GetJob(source) == v2.job then
				job = k
			end
		end
    end

	if job then
		TriggerClientEvent("kfines:open", source, false, {job = job})
	end
end)

RegisterServerCallback("traffic_tickets_get", function(source, cb, paid)
	identifier = GetIdentifiter(source)

	MySQL.Async.fetchAll("SELECT * FROM kfines WHERE citizenIdentifier=@identifier AND paid=@paid", {identifier = identifier, paid = paid}, function(result)
		
		elements = {}

		for _,v in pairs(result) do
			AddResultToTable(elements,v)
		end

		cb(elements)
	end)
end)

RegisterServerCallback("traffic_tickets_get_all", function(source, cb)

	MySQL.Async.fetchAll("SELECT * FROM kfines", {}, function(result)
		
		elements = {}

		for _,v in pairs(result) do
			AddResultToTable(elements,v)
		end

		cb(elements)
	end)
end)

function AddResultToTable(targetTable,result)
	table.insert(targetTable, {
		id = result.id,
		policeName = result.copName,
		policeRank = result.copRank,
		policeBadge = result.copBadge,
		signature = result.signature,
		citizenName = result.citizenName,
		citizenDOB = result.citizenDOB,
		citizenSex = result.citizenSex,
		fine = result.fine,
		reason = result.reason,
		date = result.date,
		payUntil = result.payUntil,
		paid = result.paid,
		afterTime = result.afterTime,
		job = result.job,
	})
end

RegisterNetEvent("kfines:apply", function(data)
	local _source = source
	ped = GetPlayerPed(_source)
	xPlayerCoords = GetEntityCoords(ped)

	correct = false

	for _,v in pairs(Config.Jobs[data.job].allowedJobs) do
		if GetJob(_source) == v.job then
			correct = true
		end
	end
	
	if not correct then
		return
	end

	if data.policeName == "" or data.policeRank == "" or data.policeBadge == "" 
	or data.citizenName == "" or data.citizenSex == -1 or data.citizenDOB == "" 
	or data.fine <= 0 or data.reason == "" or data.payUntil == "" or data.date == "" or data.signature == "" then
		ShowNotification(_source,_U("fill_ticket"))
		return
	end

	sex = "m"
	if data.citizenSex == 1 then
		sex = "f"
	end

	identifier = GetIdentifierFromData(data.citizenName,data.citizenDOB,sex)

	if identifier == nil and not Config.AllowFakePlayers then
		ShowNotification(_source, _U("not_found"))
		return
	end

	playerToShow = nil
	closest = Config.ShowDistance

	for _,v in pairs(GetPlayers()) do
		if Config.AllowFakePlayers then
			vPed = GetPlayerPed(v)
			dist = #(xPlayerCoords - GetEntityCoords(vPed))
			if dist < closest and vPed ~= ped then
				playerToShow = v
				closest = dist
			end
		else
			if identifier == GetIdentifiter(v) then
				dist = #(xPlayerCoords - GetEntityCoords(GetPlayerPed(v)))
				if dist < closest then 
					playerToShow = v
					break
				end
			end
		end
	end

	if playerToShow == nil then
		ShowNotification(_source, _U("not_found"))
		return
	end


	date = data.date:gsub("Z", " "):gsub("T", " ")
	payUntil = data.payUntil:gsub("Z", " "):gsub("T", " ")

	MySQL.Async.insert("INSERT INTO kfines(copIdentifier, copName, copRank, copBadge, citizenIdentifier, citizenName, citizenSex, citizenDOB, fine, reason, date, payUntil, signature,job) VALUES (@copIdentifier, @copName, @copRank, @copBadge, @citizenIdentifier, @citizenName, @citizenSex, @citizenDOB, @fine, @reason, CONVERT_TZ(@date, '+00:00', @tz), CONVERT_TZ(@payUntil, '+00:00', @tz), @signature, @job)",
		{
			copIdentifier = GetIdentifiter(_source),
			copName = data.policeName,
			copRank = data.policeRank,
			copBadge = data.policeBadge,
			citizenIdentifier = identifier,
			citizenName = data.citizenName,
			citizenSex = data.citizenSex,
			citizenDOB = data.citizenDOB,
			fine = data.fine,
			reason = data.reason,
			date = date,
			payUntil = payUntil,
			signature = data.signature,
			tz = Config.TimeZone,
			job = data.job
		}, function(id)
			data.id = id
			TriggerClientEvent("kfines:open", playerToShow, true, data)
			if identifier == nil then
				identifier = "Not Found"
			end
			CreateFineWebhook(_source, GetIdentifiter(_source), GetPlayerName(_source), data.policeName, identifier, data.citizenName, sex, data.citizenDOB, data.fine, data.reason, id) 
		end
	)
	ShowNotification(_source, _U("fine"))

end)

RegisterNetEvent("kfines:pay", function(id)
	Pay(id, false)
end)

function Pay(id, auto)
	MySQL.Async.fetchAll("SELECT * FROM kfines WHERE id=@id", {id = id}, function(result)
		if result[1] == nil then
			return
		end

		identifier = result[1].citizenIdentifier

		if identifier == nil then
			return
		end

		fine = result[1].fine
		if auto then
			fine = fine * Config.NotPaidModifier
		end

		citizenId = -1
		citizenNick = "Offline" 
		RemoveMoney(identifier, "bank", fine, id)
		if IsOnline(identifier) then
			citizenId = GetSourceFromIdentifier(identifier)
			citizenNick = GetPlayerName(citizenId)
			ShowNotification(citizenId, _U("paid", fine, id))
		end


		job = result[1].job

		AddSocietyMoney(Config.Jobs[job].society, fine)
		MySQL.Async.execute("UPDATE kfines SET paid=true, afterTime=@afterTime WHERE id=@id", {id = id, afterTime = auto})
		PayFineWebhook(citizenId, identifier, citizenNick, fine, id, auto, job) 
	end)
end

Citizen.CreateThread(function()
    MySQL.ready(function()
        MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `kfines` (`id` INT NOT NULL AUTO_INCREMENT , `job` TEXT NOT NULL, `copIdentifier` TEXT NOT NULL , `copName` TEXT NOT NULL , `copRank` TEXT NOT NULL , `copBadge` TEXT NOT NULL , `citizenIdentifier` TEXT NULL , `citizenName` TEXT NOT NULL ,`citizenSex` INT NOT NULL DEFAULT -1,`citizenDOB` TEXT NOT NULL , `fine` INT NOT NULL DEFAULT 0, `reason` TEXT NOT NULL , `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `payUntil` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `signature` TEXT NOT NULL , `paid` BOOLEAN NOT NULL DEFAULT FALSE, `afterTime` BOOLEAN NOT NULL DEFAULT FALSE, PRIMARY KEY (`id`)) ENGINE = InnoDB;")
    end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		MySQL.Async.fetchAll("SELECT id FROM `kfines` WHERE payUntil < CONVERT_TZ(NOW(), '+00:00', @tz) AND paid=false", {tz = Config.TimeZone}, function(result)
			for _,v in pairs(result) do
				Pay(v.id, true)
			end
		end)
	end
end)

function CreateFineWebhook(copId, copIdentifier, copNick,copName, citizenIdentifier, citizenName, citizenSex, citizenDOB, fine, reason, fineId, job) 
	if Config.WebhookURL == "" then return end
	
	local embeds = {
		{
			["title"] = "KFines - Log",
			["description"] = "Created Fine",
			["type"] = "rich",
			["color"] = 4553417,
			["fields"] = {
				{
					["name"] = "Cop Id",
					["value"] = copId,
					["inline"] = true,
				},
				{
					["name"] = "Cop Identifier",
					["value"] = copIdentifier,
					["inline"] = true,
				},
				{
					["name"] = "Cop Nick",
					["value"] = copNick,
					["inline"] = true,
				},
				{
					["name"] = "Cop Name",
					["value"] = copName,
					["inline"] = false,
				},
				{
					["name"] = "Citizen Identifier",
					["value"] = citizenIdentifier,
					["inline"] = true,
				},
				{
					["name"] = "Job",
					["value"] = job,
					["inline"] = true,
				},
				{
					["name"] = "Citizen Name",
					["value"] = citizenName,
					["inline"] = true,
				},
				{
					["name"] = "Citizen Sex",
					["value"] = citizenSex,
					["inline"] = true,
				},
				{
					["name"] = "Citizen DOB",
					["value"] = citizenDOB,
					["inline"] = false,
				},
				{
					["name"] = "Fine",
					["value"] = fine,
					["inline"] = true,
				},
				{
					["name"] = "Reason",
					["value"] = reason,
					["inline"] = true,
				},
				{
					["name"] = "Fine Id",
					["value"] = fineId,
					["inline"] = true,
				},
			},
			["footer"] = {
				["text"] = 'KFines'
			},
		}
	}
	PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({ username = "KFines - Log", avatar_url= "",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function PayFineWebhook(citizenId, citizenIdentifier, citizenNick, fine, fineId, auto, job) 
	if Config.WebhookURL == "" then return end
	
	local embeds = {
		{
			["title"] = "KFines - Log",
			["description"] = "Paid Fine",
			["type"] = "rich",
			["color"] = 4553417,
			["fields"] = {
				{
					["name"] = "Citizen Id",
					["value"] = citizenId,
					["inline"] = true,
				},
				{
					["name"] = "Citizen Identifier",
					["value"] = citizenIdentifier,
					["inline"] = true,
				},
				{
					["name"] = "Citizen Nick",
					["value"] = citizenNick,
					["inline"] = false,
				},
				{
					["name"] = "Fine",
					["value"] = fine,
					["inline"] = true,
				},
				{
					["name"] = "Fine Id",
					["value"] = fineId,
					["inline"] = true,
				},
				{
					["name"] = "Auto",
					["value"] = auto,
					["inline"] = true,
				},
				{
					["name"] = "Job",
					["value"] = job,
					["inline"] = false,
				},
			},
			["footer"] = {
				["text"] = 'KFines'
			},
		}
	}
	PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({ username = "KFines - Log", avatar_url= "",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end