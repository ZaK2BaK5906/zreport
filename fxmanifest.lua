fx_version 'cerulean'
game 'gta5'

author 'ZReport Script'
description 'Système de Report In-Game pour FiveM ESX - Version Française'
version '1.0.0'

shared_scripts {
    'config.lua'
}

server_scripts {
    'webhook.lua',
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

lua54 'yes'
