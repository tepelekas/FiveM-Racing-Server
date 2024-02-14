local newPlayer = 'INSERT INTO `players` SET `license` = ?, `name` = ?, `money` = ?, `group` = ?'
local oldPlayer = 'SELECT `identifier`, `license`, `name`, `money`, `group`, `skin`, `metadata`, `vehicles`'

oldPlayer = oldPlayer .. ' FROM `players` WHERE identifier = ?'

-- Local Functions
local function checkTable(key, val, player, Players)
	for valIndex = 1, #val do
		local value = val[valIndex]
		if not Players[value] then
			Players[value] = {}
		end

		if player[key] == value then
			Players[value][#Players[value] + 1] = player
		end
	end
end

RegisterNetEvent('nfd:server:onPlayerJoined', function()
	local _source = source

	if not NFD.Players[_source] then
		onPlayerJoined(_source)
	end
end)

function onPlayerJoined(playerId)
	local license = NFD.Functions.GetPlayerLicense(playerId)

	if license then
        if NFD.Functions.GetPlayerFromLicense(license) then
            DropPlayer(playerId, ("there was an error loading your character!\nError code: license-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s"):format(license))
        else
            local identifier = MySQL.scalar.await("SELECT `identifier` FROM players WHERE license = ?", { license })
            if identifier then
                loadPlayer(identifier, license, playerId, false)
            else
                createPlayer(identifier, playerId)
            end
        end
    else
        DropPlayer(playerId, "there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.")
    end
end

function createPlayer(license, playerId)
	local defaultGroup = 'user'
	local playerName = GetPlayerName(playerId)

	if NFD.Functions.IsPlayerAdmin(playerId) then
		print(('[^2INFO^0] Player ^5%s^0 Has been granted admin permissions via ^5Ace Perms^7.'):format(playerName))
		defaultGroup = 'admin'
	end

	local parameters = { license, playerName, Config.StartingMoney, defaultGroup }

	MySQL.prepare(newPlayer, parameters, function(identifier)
		loadPlayer(tonumber(identifier), license, playerId, true)
	end)
end

function loadPlayer(identifier, license, playerId, isNew)
	local userData = {
		money = o,
        group = 'user',
        identifier = identifier,
		name = GetPlayerName(playerId),
		metadata = {},
        dead = false,
		skin = {},
		vehicles = {},
	}

	local result = MySQL.prepare.await(oldPlayer, { identifier })
    -- Money
    userData.money = (result.money and result.money ~= '') and tonumber(result.money) or userData.money

	-- Group
    userData.group = (result.group and result.group ~= '') and result.group or userData.group
    
    -- Skin
    userData.skin = (result.skin and result.skin ~= "") and json.decode(result.skin) or { sex = userData.sex == "f" and 1 or 0 }

	-- Vehicles
	userData.vehicles = (result.vehicles and result.vehicles ~= '') and json.decode(result.vehicles) or {}
	
	-- Metadata
	userData.metadata = (result.metadata and result.metadata ~= '') and json.decode(result.metadata) or {}

	-- Player Creation
    local Player = CreateDatabasePlayer(
		playerId,
		identifier,
		license,
		userData.group,
		userData.money,
		userData.loadout,
		userData.name,
		userData.metadata
	)

    NFD.Players[playerId] = Player
    Core.playersByLicense[license] = Player

	TriggerEvent('nfd:server:playerLoaded', playerId, Player, isNew)
	Player.triggerEvent('nfd:client:playerLoaded', userData, isNew, userData.skin)
	Player.triggerEvent('nfd:client:registerSuggestions', Core.RegisteredCommands)
	print(('[^2INFO^0] Player ^5%s ^0has connected to the server. ID: ^5%s^7'):format(userData.name, playerId))
end

-- Framework Functions
function NFD.Functions.GetPlayerFromId(source)
	return NFD.Players[tonumber(source)]
end

function NFD.Functions.GetPlayerFromLicense(license)
	return Core.playersByLicense[license]
end

function NFD.Functions.GetPlayerLicense(playerId)
	local fxDk = GetConvarInt("sv_fxdkMode", 0)
	if fxDk == 1 then
		return "NFD-DEBUG-LICENCE"
	end

	local license = GetPlayerIdentifierByType(playerId, "license")
	return license
end

NFD.Functions.GetPlayers = GetPlayers

function NFD.Functions.GetExtendedPlayers(key, val)
	local Players = {}
	if type(val) == "table" then
		for _, v in pairs(NFD.Players) do
			checkTable(key, val, v, Players)
		end
	else
		for _, v in pairs(NFD.Players) do
			if key then
				if v[key] == val then
					Players[#Players + 1] = v
				end
			else
				Players[#Players + 1] = v
			end
		end
	end

	return Players
end

function NFD.Functions.IsPlayerAdmin(playerId)
	if (IsPlayerAceAllowed(playerId, "command") or GetConvar("sv_lan", "") == "true") and true or false then
		return true
	end

	local Player = NFD.Players[playerId]

	if Player then
		if Config.AdminGroups[Player.group] then
			return true
		end
	end

	return false
end

function NFD.Functions.GetVehicleType(model, player, cb)
    model = type(model) == "string" and joaat(model) or model

    if Core.vehicleTypesByModel[model] then
        return cb(Core.vehicleTypesByModel[model])
    end

    NFD.TriggerClientCallback(player, "nfd:callvack:GetVehicleType", function(vehicleType)
        Core.vehicleTypesByModel[model] = vehicleType
        cb(vehicleType)
    end, model)
end

function NFD.Functions.DiscordLog(name, title, color, message)
	local webHook = Config.DiscordLogs.Webhooks[name] or Config.DiscordLogs.Webhooks.default
	local embedData = {
		{
			["title"] = title,
			["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S"),
			["color"] = Config.DiscordLogs.Colors[color] or Config.DiscordLogs.Colors.default,
			["description"] = message,
		},
	}
	PerformHttpRequest(
		webHook,
		nil,
		"POST",
		json.encode({
			username = "Server Logs",
			avatar_url = "https://avatars.githubusercontent.com/u/30593074?s=280&v=4",
			embeds = embedData,
		}),
		{
			["Content-Type"] = "application/json",
		}
	)
end

function NFD.Functions.DiscordLogFields(name, title, color, fields)
	local webHook = Config.DiscordLogs.Webhooks[name] or Config.DiscordLogs.Webhooks.default
	local embedData = {
		{
			["title"] = title,
			["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S"),
			["color"] = Config.DiscordLogs.Colors[color] or Config.DiscordLogs.Colors.default,
			["fields"] = fields,
			["description"] = "",
		},
	}
	PerformHttpRequest(
		webHook,
		nil,
		"POST",
		json.encode({
			username = "Server Logs",
			avatar_url = "https://avatars.githubusercontent.com/u/30593074?s=280&v=4",
			embeds = embedData,
		}),
		{
			["Content-Type"] = "application/json",
		}
	)
end

function NFD.Functions.GetBucketObjects()
	return NFD.PlayerBuckets, NFD.EntityBuckets
end

function NFD.Functions.SetPlayerBucket(player, bucket)
	if player and bucket then
		local identifier = NFD.Functions.GetPlayerFromId(player).identifier
		SetPlayerRoutingBucket(player, bucket)
		NFD.PlayerBuckets[identifier] = { id = player, bucket = bucket }
		return true
	else
		return false
	end
end

RegisterNetEvent("nfd:server:setPlayerBucket", function(bucket)
	if source and bucket then
		NFD.Functions.SetPlayerBucket(source, bucket)
	end
end)

function NFD.Functions.SetEntityBucket(entity, bucket)
	if entity and bucket then
		SetEntityRoutingBucket(entity, bucket)
		NFD.EntityBuckets[entity] = { id = entity, bucket = bucket }
		return true
	else
		return false
	end
end

function NFD.Functions.GetPlayersInBucket(bucket)
	local curr_bucket_pool = {}
	if NFD.PlayerBuckets and next(NFD.PlayerBuckets) then
		for _, v in pairs(NFD.PlayerBuckets) do
			if v.bucket == bucket then
				curr_bucket_pool[#curr_bucket_pool + 1] = v.id
			end
		end
		return curr_bucket_pool
	else
		return false
	end
end

function NFD.Functions.GetEntitiesInBucket(bucket)
	local curr_bucket_pool = {}
	if NFD.EntityBuckets and next(NFD.EntityBuckets) then
		for _, v in pairs(NFD.EntityBuckets) do
			if v.bucket == bucket then
				curr_bucket_pool[#curr_bucket_pool + 1] = v.id
			end
		end
		return curr_bucket_pool
	else
		return false
	end
end

function NFD.Functions.RegisterCommand(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for _, v in ipairs(name) do
			NFD.Functions.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if Core.RegisteredCommands[name] then
		print(('[^3WARNING^7] Command ^5\'%s\' ^7already registered, overriding command'):format(name))

		if Core.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then
			suggestion.arguments = {}
		end
		if not suggestion.help then
			suggestion.help = ''
		end

		TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
	end

	Core.RegisteredCommands[name] = { group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion }

	RegisterCommand(name, function(playerId, args)
		local command = Core.RegisteredCommands[name]

		if not command.allowConsole and playerId == 0 then
			print(('[^3WARNING^7] ^5%s'):format(TranslateCap('commanderror_console')))
		else
			local Player, error = NFD.Players[playerId], nil

			if command.suggestion then
				if command.suggestion.validate then
					if #args ~= #command.suggestion.arguments then
						error = TranslateCap('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
					end
				end

				if not error and command.suggestion.arguments then
					local newArgs = {}

					for k, v in ipairs(command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								else
									error = TranslateCap('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' then
									targetPlayer = playerId
								end

								if targetPlayer then
									local xTargetPlayer = NFD.Functions.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									else
										error = TranslateCap('commanderror_invalidplayerid')
									end
								else
									error = TranslateCap('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'string' then
								local newArg = tonumber(args[k])
								if not newArg then
									newArgs[v.name] = args[k]
								else
									error = TranslateCap('commanderror_argumentmismatch_string', k)
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							elseif v.type == 'merge' then
								local lenght = 0
								for i = 1, k - 1 do
									lenght = lenght + string.len(args[i]) + 1
								end
								local merge = table.concat(args, ' ')

								newArgs[v.name] = string.sub(merge, lenght)
                            elseif v.type == 'coordinate' then
                                local coord = tonumber(args[k]:match('(-?%d+%.?%d*)'))
                                if(not coord) then
                                    error = TranslateCap('commanderror_argumentmismatch_number', k)
                                else
                                    newArgs[v.name] = coord
                                end
						    end
						end

						--backwards compatibility
						if not v.validate and not v.type then
							error = nil
						end

						if error then
							break
						end
					end

					args = newArgs
				end
			end

			if error then
				if playerId == 0 then
					print(('[^3WARNING^7] %s^7'):format(error))
				else
					Player.showNotification(error)
				end
			else
				cb(Player or false, args, function(msg)
					if playerId == 0 then
						print(('[^3WARNING^7] %s^7'):format(msg))
					else
						Player.showNotification(msg)
					end
				end)
			end
		end
	end, true)

	if type(group) == 'table' then
		for _, v in ipairs(group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

function Core.SavePlayer(Player, cb)
	if not Player.spawned then
        return cb and cb()
    end

	local parameters <const> = {
		Player.money,
		Player.group,
		json.encode(Player.getMeta()),
		Player.identifier,
	}

	MySQL.prepare("UPDATE `players` SET `money` = ?, `group` = ?, `metadata` = ? WHERE `identifier` = ?",
		parameters,
		function(affectedRows)
			if affectedRows == 1 then
				print(('[^2INFO^7] Saved player ^5"%s^7"'):format(Player.getName()))
				TriggerEvent("nfd:server:playerSaved", Player.source, Player)
			end
			if cb then
				cb()
			end
		end
	)
end

function Core.SavePlayers(cb)
	local Players <const> = NFD.Players
    if not next(Players) then
        return
    end

	local startTime = os.time()
	local parameters = {}

	for _, Player in pairs(Players) do
		parameters[#parameters + 1] = {
			Player.getMoney(),
			Player.group,
			json.encode(Player.getMeta()),
			Player.identifier,
		}
	end

	MySQL.prepare("UPDATE `players` SET `money` = ?, `group` = ?, `metadata` = ? WHERE `identifier` = ?", parameters, function(results)
		if not results then
			return
		end

		if type(cb) == "function" then
			return cb()
		end

		print(("[^2INFO^7] Saved ^5%s^7 %s over ^5%s^7 ms"):format(
			#parameters,
			#parameters > 1 and "players" or "player",
			NFD.Shared.Modules.Math.Round((os.time() - startTime) / 1000000, 2)
		))
	end)
end
