-- RegisterCommand('dv', 'admin', function(source, args)
--     local Player = NFD.Functions.GetPlayerFromId(source)
--     print('Vehicle Deleted')
-- 	if tonumber(args[1]) then
-- 		local Vehicles = ESX.OneSync.GetVehiclesInArea(GetEntityCoords(GetPlayerPed(Player.source)), tonumber(args[1]) or 1.0)
-- 		for i = 1, #Vehicles do
-- 			local Vehicle = NetworkGetEntityFromNetworkId(Vehicles[i])
-- 			if DoesEntityExist(Vehicle) then
-- 				DeleteEntity(Vehicle)
-- 			end
-- 		end
-- 	else
-- 		local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(Player.source), false)

-- 		if DoesEntityExist(PedVehicle) then
-- 			DeleteEntity(PedVehicle)
-- 		end
-- 	end
-- end, false)