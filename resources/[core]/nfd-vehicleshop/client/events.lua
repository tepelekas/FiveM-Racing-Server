local NFD = exports['nfd-core']:getCoreObject()
local Vehicles = NFD.Shared.Functions.GetConfig().Vehicles

RegisterNUICallback("openVehicleshop", function(data, cb)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = data.action,
        invoker = data.invoker,
        vehicles = Vehicles
    })
    cb('ok')
end)