fx_version 'cerulean'
game 'gta5'

author 'Scott'
description 'Advanced Pilot Job (Legal + Illegal, XP, Missions, HUD)'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/images/*.png'
}
dependency 'qb-core'
dependency 'qb-target'
dependency 'qb-menu'
