fx_version 'adamant'

game "gta5"
version '1.0'

description "This Plugins Syncs your Data automatically with RP-Admin"
shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

dependencies {
    'oxmysql'
}
