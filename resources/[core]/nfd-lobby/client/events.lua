local NFD = exports['nfd-core']:getCoreObject()
local cam = nil

local function SetCam(campos)
    if DoesCamExist(cam) then
        DestroyCam(cam, true)
    end

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", campos.x, campos.y, campos.z, -10.0, 0.0, campos.heading, 60.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end

local function openLobby(data)
    FreezeEntityPosition(PlayerPedId(), true)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openLobby',
        data = data
    })
    if DoesCamExist(cam) then DestroyCam(cam, true) end
    SetCam(Config.LobbyCamera.Vehicle)
end

exports('openLobby', openLobby)

CreateThread(function()
    while not NFD.Functions.IsPlayerLoaded() do
        Wait(0)
    end

    Wait(1000)

    local playerData = NFD.Functions.GetPlayerData()

    local data = {
        money = playerData.money,
        vehicles = playerData.vehicles
    }

    print(json.encode(data))
    openLobby(data)

    return true
end)

AddEventHandler('onResourceStop', function()
    FreezeEntityPosition(GetPlayerPed(source), false)
end)

RegisterNUICallback("openLobby", function(data, cb)
    local playerData = NFD.Functions.GetPlayerData()
    local data = {
        money = playerData.money,
        vehicles = playerData.vehicles
    }

    print(json.encode(data))
    openLobby(data)
    cb('ok')
end)

RegisterNUICallback("closeLobby", function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)