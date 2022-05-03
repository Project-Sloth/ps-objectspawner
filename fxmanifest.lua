fx_version 'cerulean'
games { 'gta5' }

author 'devyn'

client_scripts { "client/*.lua" }
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/*.lua",
}

ui_page "html/index.html"

files({
	"html/*",
})


lua54 'yes'