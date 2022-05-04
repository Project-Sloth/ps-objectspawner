fx_version 'cerulean'
game 'gta5'

author 'Project Sloth team'
description 'Object Spawner'
version '0.0.1'

lua54 'yes'

client_scripts { "client/*.lua" }
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/*.lua",
}

ui_page "html/index.html"

files({
	"html/*",
})