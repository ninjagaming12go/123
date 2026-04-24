fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'R6 Team'
description 'Logs System'
version '1.0.0'

escrow_ignore {
    'config.lua',
    'server/*.lua',
    'client/*.lua'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua',
    'server/functions.lua',
    'server/txadmin.lua',
    'server/chat.lua',
    'server/basic.lua',
    'server/explosion.lua'
}

dependency 'ox_lib'
dependency '/assetpacks'