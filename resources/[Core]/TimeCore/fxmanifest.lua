fx_version 'adamant'
games { 'gta5' };

description 'Demon Redzone Core - Fixed by Mix. '
version '1.0.0'

files {
	"weapons.meta",
}

data_file "WEAPONINFO_FILE_PATCH" "weapons.meta"

 client_script {
    "Combat/src/RMenu.lua",
    "Combat/src/menu/RageUI.lua",
    "Combat/src/menu/Menu.lua",
    "Combat/src/menu/MenuController.lua",
    "Combat/src/components/*.lua",
    "Combat/src/menu/elements/*.lua",
    "Combat/src/menu/items/*.lua",
    "Combat/src/menu/panels/*.lua",
    "Combat/src/menu/panels/*.lua",
    "Combat/src/menu/windows/*.lua",
    'Combat/cl_combat.lua'
 }


client_scripts {
	"client/*"
}

server_scripts {
    'Combat/sv_combat.lua',
    "/voicechat/vVoicesv.lua",
	"/client/vs_server.lua"
}

files {
  'data/**/*.meta',
}

data_file 'HANDLING_FILE'            'data/**/handling.meta'
data_file 'CARCOLS_FILE'            'data/**/carcols.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/**/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE'    'data/**/carvariations*.meta'

files {
	'stream/handling.meta',
}

ui_page 'killfeed/html/index.html'

files {
    'killfeed/html/index.html',
    'killfeed/html/style.css',
    'killfeed/html/app.js',
    'killfeed/html/img/*.webp',
    'killfeed/html/img/*.png',
}

client_scripts {
    'killfeed/client.lua',
}

server_scripts {
    'killfeed/server.lua',
}

--------K Menu------
client_script {
    'Z-Kmenu/client/mMenu.lua',
    'Z-Kmenu/client/kMenu.lua',
    'Z-Kmenu/config/config.lua',
    'Z-Kmenu/client/WarMenu.lua',
  }
  
  server_scripts {
    'Z-Kmenu/lua/sv_afk.lua',
    'Z-Kmenu/config/config.lua',
    'Z-Kmenu/srzdata.lua'
  }
  
  files {
    "Z-Kmenu/srzdata.json"
  }