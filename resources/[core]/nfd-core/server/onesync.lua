local function getNearbyPlayers(source, closest, distance, ignore)
	local result = {}
	local count = 0
    local playerPed
    local playerCoords

	if not distance then distance = 100 end

	if type(source) == 'number' then
		playerPed = GetPlayerPed(source)
        
		if not source then
			error("Received invalid first argument (source); should be playerId")
            return result
		end

		playerCoords = GetEntityCoords(playerPed)

        if not playerCoords then
            error("Received nil value (playerCoords); perhaps source is nil at first place?")
            return result
        end
	end

	if type(source) == 'vector3' then
		playerCoords = source

		if not playerCoords then
            error("Received nil value (playerCoords); perhaps source is nil at first place?")
            return result
        end
	end

	for _, Player in pairs(NFD.Players) do
		if not ignore or not ignore[Player.source] then
			local entity = GetPlayerPed(Player.source)
			local coords = GetEntityCoords(entity)

			if not closest then
				local dist = #(playerCoords - coords)
				if dist <= distance then
					count = count + 1
					result[count] = { id = Player.source, ped = NetworkGetNetworkIdFromEntity(entity), coords = coords, dist = dist }
				end
			else
                if Player.source ~= source then
					local dist = #(playerCoords - coords)
					if dist <= (result.dist or distance) then
						result = { id = Player.source, ped = NetworkGetNetworkIdFromEntity(entity), coords = coords, dist = dist }
					end
                end
			end
		end
	end

	return result
end

function NFD.Functions.OneSync.GetPlayersInArea(source, maxDistance, ignore)
	return getNearbyPlayers(source, false, maxDistance, ignore)
end

function NFD.Functions.OneSync.GetClosestPlayer(source, maxDistance, ignore)
	return getNearbyPlayers(source, true, maxDistance, ignore)
end

function NFD.Functions.OneSync.SpawnVehicle(source, model, coords, warp, properties)
	local vehicleProperties = properties
	local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
	properties = type(properties) == 'table' or {}
	if not coords then coords = GetEntityCoords(ped) end
	local heading = coords.w and coords.w or 0.0
	local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
	while not DoesEntityExist(veh) do Wait(0) end
	if warp then
		while GetVehiclePedIsIn(ped) ~= veh do
			Wait(0)
			TaskWarpPedIntoVehicle(ped, veh, -1)
		end
	end
	Entity(veh).state:set('VehicleProperties', vehicleProperties, true)
	while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    return veh
end

function NFD.Functions.OneSync.SpawnObject(model, coords, heading, cb)
    if type(model) == "string" then
        model = joaat(model)
    end
    local objectCoords = type(coords) == "vector3" and coords or vector3(coords.x, coords.y, coords.z)
    CreateThread(function()
        local entity = CreateObject(model, objectCoords, true, true)
        while not DoesEntityExist(entity) do
            Wait(50)
        end
        SetEntityHeading(entity, heading)
        cb(NetworkGetNetworkIdFromEntity(entity))
    end)
end

function NFD.Functions.OneSync.SpawnPed(model, coords, heading, cb)
    if type(model) == "string" then
        model = joaat(model)
    end
    CreateThread(function()
        local entity = CreatePed(0, model, coords.x, coords.y, coords.z, heading, true, true)
        while not DoesEntityExist(entity) do
            Wait(50)
        end
        cb(NetworkGetNetworkIdFromEntity(entity))
    end)
end

function NFD.Functions.OneSync.SpawnPedInVehicle(model, vehicle, seat, cb)
    if type(model) == "string" then
        model = joaat(model)
    end
    CreateThread(function()
        local entity = CreatePedInsideVehicle(vehicle, 1, model, seat, true, true)
        while not DoesEntityExist(entity) do
            Wait(50)
        end
        cb(NetworkGetNetworkIdFromEntity(entity))
    end)
end

local function getNearbyEntities(entities, coords, modelFilter, maxDistance, isPed)
    local nearbyEntities = {}
    coords = type(coords) == "number" and GetEntityCoords(GetPlayerPed(coords)) or vector3(coords.x, coords.y, coords.z)
    for _, entity in pairs(entities) do
        if not isPed or (isPed and not IsPedAPlayer(entity)) then
            if not modelFilter or modelFilter[GetEntityModel(entity)] then
                local entityCoords = GetEntityCoords(entity)
                if not maxDistance or #(coords - entityCoords) <= maxDistance then
                    nearbyEntities[#nearbyEntities + 1] = NetworkGetNetworkIdFromEntity(entity)
                end
            end
        end
    end

    return nearbyEntities
end

function NFD.Functions.OneSync.GetPedsInArea(coords, maxDistance, modelFilter)
    return getNearbyEntities(GetAllPeds(), coords, modelFilter, maxDistance, true)
end

function NFD.Functions.OneSync.GetObjectsInArea(coords, maxDistance, modelFilter)
    return getNearbyEntities(GetAllObjects(), coords, modelFilter, maxDistance)
end

function NFD.Functions.OneSync.GetVehiclesInArea(coords, maxDistance, modelFilter)
    return getNearbyEntities(GetAllVehicles(), coords, modelFilter, maxDistance)
end

local function getClosestEntity(entities, coords, modelFilter, isPed)
    local distance, closestEntity, closestCoords = 100, nil, nil
    coords = type(coords) == "number" and GetEntityCoords(GetPlayerPed(coords)) or vector3(coords.x, coords.y, coords.z)

    for _, entity in pairs(entities) do
        if not isPed or (isPed and not IsPedAPlayer(entity)) then
            if not modelFilter or modelFilter[GetEntityModel(entity)] then
                local entityCoords = GetEntityCoords(entity)
                local dist = #(coords - entityCoords)
                if dist < distance then
                    closestEntity, distance, closestCoords = entity, dist, entityCoords
                end
            end
        end
    end
    return NetworkGetNetworkIdFromEntity(closestEntity), distance, closestCoords
end

function NFD.Functions.OneSync.GetClosestPed(coords, modelFilter)
    return getClosestEntity(GetAllPeds(), coords, modelFilter, true)
end

function NFD.Functions.OneSync.GetClosestObject(coords, modelFilter)
    return getClosestEntity(GetAllObjects(), coords, modelFilter)
end

function NFD.Functions.OneSync.GetClosestVehicle(coords, modelFilter)
    return getClosestEntity(GetAllVehicles(), coords, modelFilter)
end
