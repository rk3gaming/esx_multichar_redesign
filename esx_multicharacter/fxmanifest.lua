fx_version 'cerulean'

game 'gta5'
version '1.12.4'
lua54 'yes'

dependencies { 'es_extended', 'esx_identity' }

shared_scripts { '@es_extended/imports.lua', '@es_extended/shared/utils/locale.lua', 'locales/*.lua', 'shared/*.lua', 'config.lua' }

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'server/modules/*.lua'
}

client_scripts {
   "client/modules/*.lua",
   'client/*.lua'
}

escrow_ignore {
    'shared/*.lua'
}

ui_page { 'web/build/dist/index.html' }

files { 'web/build/dist/index.html', 'web/build/dist/assets/*', 'web/build/dist/header.svg' }
