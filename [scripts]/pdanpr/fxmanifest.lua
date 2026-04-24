fx_version 'cerulean'
game 'gta5'

name 'qb-anpr-system'
description 'QBCore ANPR + Plate Reader + BOLO + MOT/Insurance'
author 'your_name'
version '1.1.0'

lua54 'yes'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'oxmysql',
    'ps-dispatch'
}