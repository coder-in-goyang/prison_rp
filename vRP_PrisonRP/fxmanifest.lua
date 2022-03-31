fx_version 'cerulean'
games { 'gta5' }

dependency "vrp"

lua54 'yes'

client_scripts{ 
	"@vrp/lib/utils.lua",
	"@vrp/client/Tunnel.lua",
	"@vrp/client/Proxy.lua",
	"client/client.lua"
}

server_scripts{
	'@vrp/lib/utils.lua',
	'@vrp/lib/Tools.lua',
	'@vrp/lib/Proxy.lua',
	"@vrp/client/Tunnel.lua",
	"server/server.lua"
}