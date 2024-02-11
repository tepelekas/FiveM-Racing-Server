fx_version 'cerulean'

game 'gta5'

description 'NFD Core'

lua54 'yes'

version '1.0'

shared_scripts {
	'locale.lua',
	'locales/en.lua',
	'config.lua',
	'config-vehicles.lua',
	'config-logs.lua',
	-- 'shared/main.lua'
}

client_scripts {
	'client/common.lua',
	'shared/functions.lua',
	'shared/modules/*.lua',
	'client/modules/callback.lua',
	'client/functions.lua',
	'client/main.lua',
	'client/events.lua',
	'client/modules/actions.lua',
	'client/modules/streaming.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/common.lua',
	'shared/functions.lua',
	'shared/modules/*.lua',
	'server/modules/callback.lua',
	'server/classes/player.lua',
    'server/functions.lua',
	'server/onesync.lua',
	'server/main.lua',
	'server/commands.lua',
	'server/events.lua',
	'server/modules/actions.lua'
}

-- ui_page 'html/index.html'

files {
	'imports.lua',
	'locale.js',
	'html/**/*'
}

dependencies {
	'/native:0x6AE51D4B',
    '/native:0xA61C8FC6',
	'oxmysql',
}