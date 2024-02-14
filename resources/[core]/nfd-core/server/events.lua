RegisterNetEvent("nfd:server:onPlayerSpawn", function()
    NFD.Players[source].spawned = true
end)

AddEventHandler("playerConnecting", function(_, _, deferrals)
	deferrals.defer()
	local playerId = source
	local license = NFD.Functions.GetPlayerLicense(playerId)

	if oneSyncState == "off" or oneSyncState == "legacy" then
		return deferrals.done(("[NFD Core] Requires Onesync Infinity to work. This server currently has Onesync set to: %s"):format(oneSyncState))
	end

	if not Core.DatabaseConnected then
		return deferrals.done("[NFD Core] OxMySQL Was Unable To Connect to your database. Please make sure it is turned on and correctly configured in your server.cfg")
	end

	if license then
		if NFD.Functions.GetPlayerFromLicense(license) then
			return deferrals.done(("[NFD Core] There was an error loading your character!\nError code: identifier-active\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same account.\n\nYour identifier: %s"):format(identifier))
		else
			return deferrals.done()
		end
	else
		return deferrals.done("[NFD Core] There was an error loading your character!\nError code: identifier-missing\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.")
	end
end)

AddEventHandler("playerDropped", function(reason)
	local playerId = source
	local Player = NFD.Functions.GetPlayerFromId(playerId)

	if Player then
		TriggerEvent("nfd:server:playerDropped", playerId, reason)

		Core.playersByLicense[Player.license] = nil
		Core.SavePlayer(Player, function()
			NFD.Players[playerId] = nil
		end)

		NFD.Functions.DiscordLogFields("connection", "Player Left", "red", {
			{ name = "Player", value = Player.name, inline = true },
			{ name = "ID", value = Player.source, inline = true },
			{ name = "Reason", value = reason, inline = true },
		})
	end
end)

AddEventHandler("nfd:server:playerLogout", function(playerId, cb)
	local Player = NFD.Functions.GetPlayerFromId(playerId)
	if Player then
		TriggerEvent("nfd:server:playerDropped", playerId)

<<<<<<< HEAD
		Core.playersByLicense[Player.license] = nil
=======
		Core.playersByLicense[Player.identifier] = nil
>>>>>>> origin/beta
		Core.SavePlayer(Player, function()
			NFD.Players[playerId] = nil
			if cb then
				cb()
			end
		end)
	end
	TriggerClientEvent("nfd:client:onPlayerLogout", playerId)
end)

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(50000)
			Core.SavePlayers()
		end)
	end
end)

AddEventHandler("txAdmin:events:serverShuttingDown", Core.SavePlayers)
