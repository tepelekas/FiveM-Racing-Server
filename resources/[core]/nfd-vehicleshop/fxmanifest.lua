fx_version 'cerulean'

game 'gta5'

description 'NFD Vehicle Shop'

lua54 'yes'

version '1.0'

<<<<<<< HEAD
shared_scripts {
	'config.lua',
	-- 'shared/main.lua'
}
=======
-- shared_scripts {
-- 	'config.lua',
-- 	'shared/main.lua'
-- }
>>>>>>> origin/beta

client_scripts {
	-- 'client/functions.lua',
	-- 'client/main.lua',
	'client/events.lua'
}

<<<<<<< HEAD
server_scripts {
-- 	'@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}
=======
-- server_scripts {
-- 	'@oxmysql/lib/MySQL.lua',
--     'server/main.lua'
-- }
>>>>>>> origin/beta

ui_page 'html/index.html'

files {
	'html/**/*'
}

-- dependencies {
-- 	'oxmysql',
-- }