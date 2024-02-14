RegisterNetEvent('nfd:client:showNotification', function(msg, notifytype, length)
    NFD.Functions.ShowNotification(msg, notifytype, length)
end)

RegisterNetEvent('nfd:client:showAdvancedNotification', function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
    NFD.Functions.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
end)

RegisterNetEvent('nfd:client:showHelpNotification', function(msg, thisFrame, beep, duration)
    NFD.Functions.ShowHelpNotification(msg, thisFrame, beep, duration)
end)

RegisterNetEvent('nfd:client:requestModel', NFD.Modules.Streaming.RequestModel)

RegisterNetEvent('nfd:client:playerLoaded', function(Player, _, skin)
	NFD.PlayerData = Player

	NFD.Functions.SpawnPlayer(skin, Config.DefaultSpawnPoint, function()
		TriggerEvent('nfd:client:onPlayerSpawn')
		TriggerServerEvent('nfd:server:onPlayerSpawn')
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
	end)

	while not DoesEntityExist(NFD.PlayerData.ped) do
        Wait(1)
    end
    
	NFD.PlayerLoaded = true

	local timer = GetGameTimer()
    while not HaveAllStreamingRequestsCompleted(NFD.PlayerData.ped) and (GetGameTimer() - timer) < 2000 do
        Wait(0)
    end

	for i = 1, #(Config.RemoveHudComponents) do
		if Config.RemoveHudComponents[i] then
			SetHudComponentPosition(i, 999999.0, 999999.0)
		end
	end

	local playerId = PlayerId()

	if Config.DisableNPCDrops then
		for i = 1, #Config.DisabledPickups do
			ToggleUsePickupsForPlayer(playerId, Config.DisabledPickups[i], false)
		end
	end

	if Config.DisableWeaponAutoSwap then
		SetWeaponsNoAutoswap(true)
	end

	if Config.DisableWeaponWheel or Config.DisableAimAssist or Config.DisableVehicleRewards then
		CreateThread(function()
			while true do
				if Config.DisableWeaponWheel then
					BlockWeaponWheelThisFrame()
				end

				if Config.DisableAimAssist then
					if IsPedArmed(NFD.PlayerData.ped, 4) then
						SetPlayerLockonRangeOverride(playerId, 2.0)
					end
				end

				if Config.DisableVehicleRewards then
					DisablePlayerVehicleRewards(playerId)
				end

				Wait(0)
			end
		end)
	end

	DisplayRadar(false)
	LocalPlayer.state.radar = false

	if Config.DisableDispatchServices then
		for i = 1, 15 do
			EnableDispatchService(i, false)
		end
	end

	if Config.DisableScenarios then
		for _, v in pairs(Config.Scenarios) do
			SetScenarioTypeEnabled(v, false)
		end
	end

	if IsScreenFadedOut() then
        DoScreenFadeIn(500)
    end

	exports['nfd-lobby']:openLobby(NFD.PlayerData)
end)

RegisterNetEvent('nfd:client:onPlayerLogout', function()
	NFD.PlayerLoaded = false
end)

RegisterNetEvent('nfd:client:setMoney', function(money)
	NFD.PlayerData.money = money
	NFD.Functions.SetPlayerData("money", NFD.PlayerData.money)
end)

RegisterNetEvent('nfd:client:registerSuggestions', function(registeredCommands)
	for name, command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

if not Config.EnableWantedLevel then
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)
end

AddStateBagChangeHandler('VehicleProperties', nil, function(bagName, _, value)
	if not value then
		return
	end

	local netId = bagName:gsub('entity:', '')
	local timer = GetGameTimer()
	while not NetworkDoesEntityExistWithNetworkId(tonumber(netId)) do
		Wait(0)
		if GetGameTimer() - timer > 10000 then
			return
		end
	end

	local vehicle = NetToVeh(tonumber(netId))
	local timer2 = GetGameTimer()
	while NetworkGetEntityOwner(vehicle) ~= PlayerId() do
		Wait(0)
		if GetGameTimer() - timer2 > 10000 then
			return
		end
	end

	NFD.Functions.Game.SetVehicleProperties(vehicle, value)
end)

AddStateBagChangeHandler('metadata', 'player:' .. tostring(GetPlayerServerId(PlayerId())), function(_, key, val)
	NFD.Functions.SetPlayerData(key, val)
end)