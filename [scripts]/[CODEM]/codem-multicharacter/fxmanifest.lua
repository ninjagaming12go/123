fx_version 'cerulean'
game 'gta5'
version '1.6'
author 'aiakoscodem'

shared_scripts {
	'config/*.lua',
}

client_scripts {
	'client/*.lua',
	'editable/clientframework/*.lua',
	'editable/animation/*.lua',
	'config/clothes.lua',

}
server_scripts {
	-- '@mysql-async/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'mysql-async'.:warning:
	'@oxmysql/lib/MySQL.lua', --:warning:PLEASE READ:warning:; Uncomment this line if you use 'oxmysql'.:warning:
	'server/server.lua',
	'server/utility.lua',
	'editable/serverframework/*.lua',
}

ui_page "html/index.html"

files {
	'html/index.html',
	'html/css/*.css',
	'html/fonts/*.TTF',
	'html/fonts/*.*',
	'html/templateimages/**/*.svg',
	'html/templateimages/*.png',
	'html/js/*.js',
	'html/js/**/*.js',
	'html/js/**/*.css',
}

escrow_ignore {
	'editable/*/*.lua',
	'config/*.lua',
	'server/utility.lua',
	'client/utility.lua',
}

lua54 'yes'

dependency '/assetpacks'