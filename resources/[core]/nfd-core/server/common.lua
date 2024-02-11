NFD = {}
NFD.Functions = {}
NFD.Functions.OneSync = {}
NFD.Players = {}
NFD.PlayerBuckets = {}
NFD.EntityBuckets = {}
NFD.Callbacks = {}
Core = {}
Core.RegisteredCommands = {}
Core.DatabaseConnected = false
Core.playersByLicense = {}

exports('getCoreObject', function()
	return NFD
end)

local function StartDBSync()
	CreateThread(function()
		local interval <const> = 10 * 60 * 1000
		while true do
            Wait(interval)
			Core.SavePlayers()
		end
	end)
end

MySQL.ready(function()
	Core.DatabaseConnected = true
	
	print(('[^2INFO^7] ^3NFD Core %s^0 initialized!'):format(GetResourceMetadata(GetCurrentResourceName(), "version", 0)))
	StartDBSync()
end)
