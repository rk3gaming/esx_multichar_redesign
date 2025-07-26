fx_version 'adamant'

game 'gta5'
lua54 'yes'
version '1.12.4'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'@ox_lib/init.lua',
	'locales/*.lua',
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/functions.lua',
	'server/db.lua',
	'server/main.lua'
}

client_scripts {
	'client/*.lua'
}

escrow_ignore {
	'server/db.lua',
	'server/functions.lua',
}

files {
	'web/build/dist/index.html',
	'web/build/dist/assets/**',
}

ui_page 'web/build/dist/index.html'

dependency 'es_extended'
