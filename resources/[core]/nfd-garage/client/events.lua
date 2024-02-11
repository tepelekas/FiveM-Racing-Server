-- -- Trigger the event to show the garage menu
-- RegisterCommand("openGarage", function()
--     TriggerEvent("nfd-garage:client:showGarage")
-- end, false)

-- -- Listen for an event to show the garage
-- RegisterNetEvent("nfd-garage:client:showGarage", function()
--     SetNuiFocus(true, true)
--     SendNUIMessage({
--         action = 'openGarage',
--         invoker = 'command'
--     })
-- end)

-- Listen for an event to show the garage
RegisterNUICallback("openGarage", function(data, cb)
    print(data.action, data.invoker)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = data.action,
        invoker = data.invoker
    })
    cb('ok')
end)

-- -- Handling the event when the player has finished with the garage
-- RegisterNUICallback("nfd-garage:NUIcallback:purchaseComplete", function()
--     -- Code to return to the lobby UI
-- end)

-- -- Handling the event when the player wants to return to the lobby without purchase
-- RegisterNUICallback("closeGarage", function()
--     SetNuiFocus(false, false)
-- end)

-- -- Handling the event when the player repairs his vehicle
-- RegisterNUICallback("nfd-garage:NUIcallback:repairVehicle", function()
--     -- Code to repair the vehicle
-- end)