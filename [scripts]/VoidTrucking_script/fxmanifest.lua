fx_version 'cerulean'
game 'gta5'

author 'Rxider'
description 'Advanced Trucking + Dealership System'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua',
    'client_trucking.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'html/job.html'

files {
    'html/job.html',
    'html/style.css',
    'html/main.js',
    'html/*.png',
}
dependencies {
    'qb-core',
    'qb-target'
}
