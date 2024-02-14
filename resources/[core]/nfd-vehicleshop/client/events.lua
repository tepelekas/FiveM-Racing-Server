<<<<<<< HEAD
local lastVehicle = nil

local function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or joaat(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(0)
			DisableAllControlActions(0)
		end
	end
end

local function DeleteDisplayVehicleInsideShop()
	local attempt = 0

	if lastVehicle and DoesEntityExist(lastVehicle) then
		while DoesEntityExist(lastVehicle) and not NetworkHasControlOfEntity(lastVehicle) and attempt < 100 do
			Wait(100)
			NetworkRequestControlOfEntity(lastVehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(lastVehicle) and NetworkHasControlOfEntity(lastVehicle) then
			NFD.Functions.Game.DeleteVehicle(lastVehicle)
            lastVehicle = nil
		end
	end
end
=======
local NFD = exports['nfd-core']:getCoreObject()
local Vehicles = NFD.Shared.Functions.GetConfig().Vehicles
>>>>>>> origin/beta

RegisterNUICallback("openVehicleshop", function(data, cb)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = data.action,
<<<<<<< HEAD
        invoker = data.invoker
    })
    cb('ok')
end)

RegisterNUICallback('changeColor', function(data, cb)
    if DoesEntityExist(lastVehicle) then
		rgb = data.color
		SetVehicleCustomPrimaryColour(lastVehicle, tonumber(rgb.r), tonumber(rgb.g), tonumber(rgb.b))
		SetVehicleCustomSecondaryColour(lastVehicle, tonumber(rgb.r), tonumber(rgb.g), tonumber(rgb.b))
	end
    cb('ok')
end)

RegisterNUICallback('getVehicles', function(data, cb)
    cb(Config.Vehicles)
end)

RegisterNUICallback('closeVehicleshop', function(data, cb)
    SetNuiFocus(false, false)
    DeleteDisplayVehicleInsideShop()
    cb('ok')
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    local vehicleModel = (type(data.vehicle.hashname) == "number" and data.vehicle.hashname or joaat(data.vehicle.hashname))
    WaitForVehicleToLoad(vehicleModel)
    NFD.Functions.Game.SpawnVehicle(vehicleModel, Config.SpawnCoords, Config.SpawnCoords.w, function(vehicle)
        DeleteDisplayVehicleInsideShop()
        FreezeEntityPosition(vehicle, true)
        -- SetModelAsNoLongerNeeded(vehicleModel)
        SetVehicleNumberPlateText(vehicle, "TEST")
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleOnGroundProperly(vehicle)
        lastVehicle = vehicle
        cb('ok')
    end, false)
end)

RegisterCommand('del', function(source, args)
    local coords = GetEntityCoords(PlayerPedId())
    local vehs = NFD.Functions.Game.GetVehiclesInArea(coords, 50.0)
    for _, vehicle in ipairs(vehs) do
        local vehcoords = GetEntityCoords(vehicle)
        local distance = (#coords - #vehcoords)

        if distance < 50.0 then -- Adjust the radius as needed
            NFD.Functions.Game.DeleteVehicle(joaat(vehicle))
        end
    end
end, false)
=======
        invoker = data.invoker,
        vehicles = Vehicles
    })
    cb('ok')
end)
>>>>>>> origin/beta
