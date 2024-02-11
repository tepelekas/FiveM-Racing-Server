CreateThread(function()
	while true do
		Wait(100)
		if NetworkIsPlayerActive(PlayerId()) then
            DoScreenFadeOut(0)
			Wait(500)
			TriggerServerEvent('nfd:server:onPlayerJoined')
			break
		end
	end
end)

CreateThread(function()
    while Config.DiscordPresence.IsEnabled do
        SetDiscordAppId(Config.DiscordPresence.ApplicationId)
        SetDiscordRichPresenceAsset(Config.DiscordPresence.IconLarge)
        SetDiscordRichPresenceAssetText(Config.DiscordPresence.IconLargeHoverText)
        SetDiscordRichPresenceAssetSmall(Config.DiscordPresence.IconSmall)
        SetDiscordRichPresenceAssetSmallText(Config.DiscordPresence.IconSmallHoverText)

        if Config.DiscordPresence.ShowPlayerCount then
            NFD.Modules.Callbacks.TriggerServerCallback('nfd:callback:GetCurrentPlayers', function(result)
                SetRichPresence('Players: ' .. result .. '/' .. Config.DiscordPresence.MaxPlayers)
            end)
        end

        if Config.DiscordPresence.EnableButtons and Config.DiscordPresence.Buttons and type(Config.DiscordPresence.Buttons) == "table" then
            for i, v in pairs(Config.DiscordPresence.Buttons) do
                SetDiscordRichPresenceAction(i - 1,
                    v.text,
                    v.url
                )
            end
        end

        Wait(Config.DiscordPresence.UpdateRate)
    end
end)