NFD = exports['nfd-core']:getCoreObject()

if not IsDuplicityVersion() then -- Only register this event for the client
    AddEventHandler('bfd:client:setPlayerData', function(key, val, last)
        if GetInvokingResource() == 'nfd-core' then
            NFD.PlayerData[key] = val
            if OnPlayerData then
                OnPlayerData(key, val, last)
            end
        end
    end)

    RegisterNetEvent('nfd:client:playerLoaded', function(Player)
        NFD.PlayerData = Player
        NFD.PlayerLoaded = true
    end)

    RegisterNetEvent('nfd:client:onPlayerLogout', function()
        NFD.PlayerLoaded = false
        NFD.PlayerData = {}
    end)
end