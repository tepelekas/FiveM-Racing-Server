NFD.Functions.RegisterCommand('setmoney', 'admin', function(Player, args, showError)
	if not args.amount then
		return showError(TranslateCap('command_givemoney_invalid'))
	end
	args.playerId.setMoney(args.amount, "Government Grant")
	if Config.AdminLogging then
		NFD.Functions.DiscordLogFields("user_actions", "Set Money /setmoney Triggered!", "yellow", {
			{ name = "Player",  value = Player.name,        inline = true },
			{ name = "ID",      value = Player.source,      inline = true },
			{ name = "Target",  value = args.playerId.name, inline = true },
			{ name = "Amount",  value = args.amount,        inline = true },
		})
	end
end, true, {
	help = TranslateCap('command_setmoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' },
		{ name = 'amount',   help = TranslateCap('command_setmoney_amount'), type = 'number' }
	}
})

NFD.Functions.RegisterCommand('givemoney', 'admin', function(Player, args, showError)
	if not args.amount then
		return showError(TranslateCap('command_givemoney_invalid'))
	end
	args.playerId.addMoney(args.amount, "Government Grant")
	if Config.AdminLogging then
		NFD.Functions.DiscordLogFields("user_actions", "Give Money /givemoney Triggered!", "yellow", {
			{ name = "Player",  value = Player.name,        inline = true },
			{ name = "ID",      value = Player.source,      inline = true },
			{ name = "Target",  value = args.playerId.name, inline = true },
			{ name = "Amount",  value = args.amount,        inline = true },
		})
	end
end, true, {
	help = TranslateCap('command_givemoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'),  type = 'player' },
		{ name = 'amount',   help = TranslateCap('command_givemoney_amount'), type = 'number' }
	}
})

NFD.Functions.RegisterCommand('removemoney', 'admin', function(Player, args, showError)
	if not args.amount then
		return showError(TranslateCap('command_removemoney_invalid'))
	end
	args.playerId.removeMoney(args.amount, "Government Tax")
	if Config.AdminLogging then
		NFD.Functions.DiscordLogFields("user_actions", "Remove Money /removemoney Triggered!", "yellow", {
			{ name = "Player",  value = Player.name,        inline = true },
			{ name = "ID",      value = Player.source,      inline = true },
			{ name = "Target",  value = args.playerId.name, inline = true },
			{ name = "Amount",  value = args.amount,        inline = true },
		})
	end
end, true, {
	help = TranslateCap('command_removemoney'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'),    type = 'player' },
		{ name = 'amount',   help = TranslateCap('command_removemoney_amount'), type = 'number' }
	}
})

NFD.Functions.RegisterCommand('save', 'admin', function(_, args)
	Core.SavePlayer(args.playerId)
	print(('[^2Info^0] Saved Player - ^5%s^0'):format(args.playerId.source))
end, true, {
	help = TranslateCap('command_save'),
	validate = true,
	arguments = {
		{ name = 'playerId', help = TranslateCap('commandgeneric_playerid'), type = 'player' }
	}
})

NFD.Functions.RegisterCommand('saveall', 'admin', function()
	Core.SavePlayers()
end, true, { help = TranslateCap('command_saveall') })

NFD.Functions.RegisterCommand('group', { "user", "admin" }, function(Player)
	print(('%s, you are currently: ^5%s^0'):format(Player.name, Player.group))
end, true)
