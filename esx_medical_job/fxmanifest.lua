fx_version 'cerulean'
game 'gta5'

author 'ESX Medical Job'
description 'Script de job médical scientifique ESX avec ox_target'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config/config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/utils.lua',
    'client/main.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'es_extended',
    'ox_target',
    'ox_lib',
    'oxmysql'
}
