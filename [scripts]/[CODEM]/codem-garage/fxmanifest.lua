fx_version 'cerulean'
game 'gta5'
author 'Magni#0247'
lua54 'yes'

description 'mGarage'
version '2.7'

shared_scripts {
    'config.lua',
}

client_scripts {
    'GetFrameworkObject.lua',
    'client/main.lua',
    'client/function.lua',
    'client/vehicle_name.lua'
}

server_scripts {
    -- '@mysql-async/lib/MySQL.lua',
	'@oxmysql/lib/MySQL.lua',
    'GetFrameworkObject.lua',
    'server/function.lua',
	'server/main.lua'
}

ui_page 'nui/index.html'

files {
    'nui/*.css',
    'nui/index.html',
    'nui/fonts/*.*',
    'nui/images/*.*',
    'nui/images/logo/*.*',
    'nui/images/cars/*.*',
    'nui/*.js'
}

escrow_ignore {
    'GetFrameworkObject.lua',
    'config.lua',
    'client/vehicle_name.lua',
    'client/function.lua',
    'server/function.lua',
}
dependency '/assetpacks'