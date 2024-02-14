fx_version 'cerulean'

game 'gta5'

description 'NFD Lobby'

lua54 'yes'

version '1.0'

shared_scripts {
	'config.lua',
	-- 'shared/main.lua'
}

client_scripts {
	-- 'client/functions.lua',
	-- 'client/main.lua',
	'client/events.lua'
}

-- server_scripts {
-- 	'@oxmysql/lib/MySQL.lua',
--     'server/main.lua'
-- }

ui_page 'html/index.html'

files {
	'html/**/*'
}

-- dependencies {
-- 	'oxmysql',
-- }