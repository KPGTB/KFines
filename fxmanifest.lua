local framework = 'esx' -- esx | qb
local mysql = "mysql-async" -- mysql-async | oxmysql

fx_version 'cerulean'
game 'gta5'

author 'KPG-TB'
description 'KFines is advanced Traffic Tickets system that allows creating tickets for players by cops, that can be paid later'
version '1.0.0'

ui_page 'web/build/index.html'

files {
    'web/build/app.js',
    'web/build/index.html',
    'web/assets/**.*',
    'web/styles/**.css'
}

client_scripts {
    '@es_extended/locale.lua',
    'framework/'..framework..'/client.lua',
    'locales/**.lua',
    'client/**.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'framework/'..framework..'/server.lua',
    'locales/**.lua',
    'server/**.lua',
    '@'..mysql..'/lib/MySQL.lua'
}

shared_script 'shared/config.lua'