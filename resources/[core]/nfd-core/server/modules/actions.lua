RegisterNetEvent('nfd:server:playerPedChanged')
RegisterNetEvent('nfd:server:playerJumping')
RegisterNetEvent('nfd:server:enteringVehicle')
RegisterNetEvent('nfd:server:enteringVehicleAborted')
RegisterNetEvent('nfd:server:enteredVehicle')
RegisterNetEvent('nfd:server:exitedVehicle')

if Config.EnableDebug then
    AddEventHandler('nfd:server:enteringVehicle', function(plate, seat, netId)
        print('nfd:server:enteringVehicle', 'source', source, 'plate', plate, 'seat', seat, 'netId', netId)
    end)

    AddEventHandler('nfd:server:enteringVehicleAborted', function()
        print('nfd:server:enteringVehicleAborted', source)
    end)

    AddEventHandler('nfd:server:enteredVehicle', function(plate, seat, displayName, netId)
        print('nfd:server:enteredVehicle', 'source', source, 'plate', plate, 'seat', seat, 'displayName', displayName, 'netId', netId)
    end)

    AddEventHandler('nfd:server:exitedVehicle', function(plate, seat, displayName, netId)
        print('nfd:server:exitedVehicle', 'source', source, 'plate', plate, 'seat', seat, 'displayName', displayName, 'netId', netId)
    end)
end
