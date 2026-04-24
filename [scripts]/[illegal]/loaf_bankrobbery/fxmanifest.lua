fx_version "cerulean"
game "gta5"
lua54 "yes"
use_experimental_fxv2_oal "yes"

name "loaf_bankrobbery"
author "Loaf Scripts"
description "Bank robbery script for ESX and QBCore"
version "2.2.7"

shared_script {
    "@ox_lib/init.lua",
    "config.lua",
    "shared/*.lua",
}

client_script {
    "client/**/*.lua"
}

server_script {
    "server/**/*.lua"
}

escrow_ignore {
    "config.lua",
    "shared/**/*.lua",
    "*/framework/*.lua",

    "client/client.lua",
    "client/creator.lua",
    "client/functions.lua",
    "client/interact.lua",

    "server/functions.lua",
    "server/objectmanager.lua",
    "server/server.lua",
}

dependency {
    "/onesync",
    "/native:0x58040420", -- spawning objects on server side
    "ox_lib"
}

dependency '/assetpacks'