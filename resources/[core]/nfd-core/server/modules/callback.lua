local serverCallbacks = {}
local clientRequests = {}
local RequestId = 0

NFD.Callbacks.RegisterServerCallback = function(eventName, callback)
	serverCallbacks[eventName] = callback
end

RegisterNetEvent('nfd:callback:triggerServerCallback', function(eventName, requestId, invoker, ...)
	if not serverCallbacks[eventName] then
		return print(('[^1ERROR^7] Server Callback not registered, name: ^5%s^7, invoker resource: ^5%s^7'):format(eventName, invoker))
	end

	local source = source

	serverCallbacks[eventName](source, function(...)
		TriggerClientEvent('nfd:callback:serverCallback', source, requestId, invoker, ...)
	end, ...)
end)

NFD.Callbacks.TriggerClientCallback = function(player, eventName, callback, ...)
	clientRequests[RequestId] = callback

	TriggerClientEvent('nfd:callback:triggerClientCallback', player, eventName, RequestId, GetInvokingResource() or "unknown", ...)

	RequestId = RequestId + 1
end

RegisterNetEvent('nfd:callback:clientCallback', function(requestId, invoker, ...)
	if not clientRequests[requestId] then
		return print(('[^1ERROR^7] Client Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.'):format(requestId, invoker))
	end

	clientRequests[requestId](...)
	clientRequests[requestId] = nil
end)

NFD.Callbacks.RegisterServerCallback('nfd:callback:GetCurrentPlayers', function(source, cb, players)
	cb(#GetPlayers())
end)

NFD.Callbacks.RegisterServerCallback("nfd:callback:getPlayerData", function(source, cb)
	local Player = NFD.Functions.GetPlayerFromId(source)

	cb({
		identifier = Player.identifier,
		money = Player.getMoney(),
		metadata = Player.getMeta()
	})
end)

NFD.Callbacks.RegisterServerCallback("nfd:callback:getOtherPlayerData", function(_, cb, target)
	local Player = NFD.Functions.GetPlayerFromId(target)

	cb({
		identifier = Player.identifier,
		money = Player.getMoney(),
		metadata = Player.getMeta()
	})
end)

NFD.Callbacks.RegisterServerCallback("nfd:callback:getPlayerNames", function(source, cb, players)
	players[source] = nil

	for playerId, _ in pairs(players) do
		local Player = NFD.Functions.GetPlayerFromId(playerId)

		if Player then
			players[playerId] = Player.getName()
		else
			players[playerId] = nil
		end
	end

	cb(players)
end)

NFD.Callbacks.RegisterServerCallback("nfd:callback:spawnVehicle", function(source, cb, vehData)
    local ped = GetPlayerPed(source)
    NFD.Functions.OneSync.SpawnVehicle(vehData.model or `ADDER`, vehData.coords or GetEntityCoords(ped), vehData.coords.w or 0.0, vehData.props or {}, function(id)
        if vehData.warp then
            local vehicle = NetworkGetEntityFromNetworkId(id)
            local timeout = 0
            while GetVehiclePedIsIn(ped) ~= vehicle and timeout <= 15 do
                Wait(0)
                TaskWarpPedIntoVehicle(ped, vehicle, -1)
                timeout += 1
            end
        end
        cb(id)
    end)
end)