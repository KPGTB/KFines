fx_version 'cerulean'
game 'gta5'

author 'KPG-TB'
description 'A simple FiveM (Lua) + ReactJS template with some utils'
version '1.0.0'

ui_page 'web/build/index.html'

files {
    'web/build/app.js',
    'web/build/index.html',
    'web/assets/**.*',
    'web/styles/**.css'
}

client_scripts {
    'client/**.lua'
}

server_scripts {
    'server/**.lua'
}