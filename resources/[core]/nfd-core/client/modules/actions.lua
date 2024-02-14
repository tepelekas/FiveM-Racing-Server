local isInVehicle, isEnteringVehicle, isJumping, inPauseMenu = false, false, false, false
local playerPed = PlayerPedId()
local current = {}
LocalPlayer.state.inVehicle = isInVehicle
LocalPlayer.state.inPauseMenu = inPauseMenu

local function GetPedVehicleSeat(ped, vehicle)
    for i = -1, 16 do
        if GetPedInVehicleSeat(vehicle, i) == ped then
            return i
        end
    end
    return -1
end

local function GetData(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end
    local model = GetEntityModel(vehicle)
    local displayName = GetDisplayNameFromVehicleModel(model)
    local netId = vehicle
    if NetworkGetEntityIsNetworked(vehicle) then
        netId = VehToNet(vehicle)
    end
    return displayName, netId
end

CreateThread(function()
    while not NFD.PlayerLoaded do Wait(200) end
    while true do
        NFD.Functions.SetPlayerData("coords", GetEntityCoords(playerPed))

        if IsPauseMenuActive() and not inPauseMenu then
            inPauseMenu = true
            LocalPlayer.state.inPauseMenu = true
            TriggerEvent('nfd:client:pauseMenuActive', inPauseMenu)
        elseif not IsPauseMenuActive() and inPauseMenu then
            inPauseMenu = false
            LocalPlayer.state.inPauseMenu = false
            TriggerEvent('nfd:client:pauseMenuActive', inPauseMenu)
        end

        if not isInVehicle and not IsPlayerDead(PlayerId()) then
            if DoesEntityExist(GetVehiclePedIsTryingToEnter(playerPed)) and not isEnteringVehicle then
                -- trying to enter a vehicle!
                local vehicle = GetVehiclePedIsTryingToEnter(playerPed)
                local plate = GetVehicleNumberPlateText(vehicle)
                local seat = GetSeatPedIsTryingToEnter(playerPed)
                local _, netId = GetData(vehicle)
                isEnteringVehicle = true
                TriggerEvent('nfd:client:enteringVehicle', vehicle, plate, seat, netId)
                TriggerServerEvent('nfd:server:enteringVehicle', plate, seat, netId)
            elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(playerPed)) and
                not IsPedInAnyVehicle(playerPed, true) and isEnteringVehicle then
                -- vehicle entering aborted
                TriggerEvent('nfd:client:enteringVehicleAborted')
                TriggerServerEvent('nfd:server:enteringVehicleAborted')
                isEnteringVehicle = false
            elseif IsPedInAnyVehicle(playerPed, false) then
                -- suddenly appeared in a vehicle, possible teleport
                isEnteringVehicle = false
                isInVehicle = true
                LocalPlayer.state.inVehicle = true
                current.vehicle = GetVehiclePedIsUsing(playerPed)
                current.seat = GetPedVehicleSeat(playerPed, current.vehicle)
                current.plate = GetVehicleNumberPlateText(current.vehicle)
                current.displayName, current.netId = GetData(current.vehicle)
                TriggerEvent('nfd:client:enteredVehicle', current.vehicle, current.plate, current.seat, current.displayName, current.netId)
                TriggerServerEvent('nfd:server:enteredVehicle', current.plate, current.seat, current.displayName, current.netId)
            end
        elseif isInVehicle then
            if not IsPedInAnyVehicle(playerPed, false) or IsPlayerDead(PlayerId()) then
                -- bye, vehicle
                TriggerEvent('nfd:client:exitedVehicle', current.vehicle, current.plate, current.seat, current.displayName, current.netId)
                TriggerServerEvent('nfd:server:exitedVehicle', current.plate, current.seat, current.displayName, current.netId)
                isInVehicle = false
                LocalPlayer.state.inVehicle = false
                current = {}
            end
        end
        Wait(200)
    end
end)

if Config.EnableDebug then
    AddEventHandler('nfd:client:enteringVehicle', function(vehicle, plate, seat, netId)
        print('nfd:client:enteringVehicle', 'vehicle', vehicle, 'plate', plate, 'seat', seat, 'netId', netId)
    end)

    AddEventHandler('nfd:client:enteringVehicleAborted', function()
        print('nfd:client:enteringVehicleAborted')
    end)

    AddEventHandler('nfd:client:enteredVehicle', function(vehicle, plate, seat, displayName, netId)
        print('nfd:client:enteredVehicle', 'vehicle', vehicle, 'plate', plate, 'seat', seat, 'displayName', displayName, 'netId', netId)
    end)

    AddEventHandler('nfd:client:exitedVehicle', function(vehicle, plate, seat, displayName, netId)
        print('nfd:client:exitedVehicle', 'vehicle', vehicle, 'plate', plate, 'seat', seat, 'displayName', displayName, 'netId', netId)
    end)
end
