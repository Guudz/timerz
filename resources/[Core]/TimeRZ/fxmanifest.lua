fx_version 'cerulean'
games { 'gta5' }

----------------------------- Fivem Exports -----------------------------------

server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"
server_export "roundEnded"
export 'getRandomSpawnPoint'
export 'spawnPlayer'
export 'addSpawnPoint'
export 'removeSpawnPoint'
export 'loadSpawns'
export 'setAutoSpawn'
export 'setAutoSpawnCallback'
export 'forceRespawn'

exports {
	'DoShortHudText',
	'DoHudText',
	"SendAlert",
	"DoLongHudText",
	"DoCustomHudText",
	"PersistentHudText",
}

resource_type 'map' { gameTypes = { ['basic-gamemode'] = true } }
resource_type 'gametype' { name = 'Freeroam' }
map 'Z-Default/map.lua'
client_script 'Z-Default/basic_client.lua'
this_is_a_map 'yes'

------------------------- Client & Server Scripts ----------------------------

client_script 'Z-Events/deathevents.lua'
client_script 'Z-Events/vehiclechecker.lua'


client_scripts {
	"Z-Basics/defaults/*",
       
    
}

server_scripts {
	"Z-Basics/server/*",
	

}

client_scripts {
  'Z-Basics/cl_deathscript.lua',
  'Z-Basics/cl_healplayer.lua',
  'Z-Basics/cl_idsabovehead.lua',
  'Z-Basics/cl_hud.lua',
  'Z-Basics/cl_rolltime.lua',
  'Z-Basics/cl-runspeed.lua', 
  'Z-Basics/functionD&H.lua',
  'Z-Basics/roleclient.lua',

}

loadscreen 'Z-Load/index.html'
files {

   'Z-Load/index.html',
   'Z-Load/keks.css',
   'Z-Load/config.js',
   'Z-Load/music/Loading.mp3',
   'Z-Load/pause.js',
   'Z-Load/bg.png'
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

----------------------------------KillFeed----------------------

client_scripts {
  "Z-Feed/threads.lua",
  "Z-Feed/scaleforms.lua",
  "Z-Feed/GameEventTriggered.lua",
  "Z-Feed/HudColors.lua",
  "Z-Feed/Config.lua",
  "Z-Feed/nbk_cstyle_killfeed.lua",
}

server_scripts {
"Z-Feed/sv.lua",

}


----------------------------------Logs----------------------

server_script 'Z-Logs/config.lua'
client_script 'Z-Logs/config.lua'

server_script 'Z-Logs/server/server.lua'
server_script 'Z-Logs/versioncheck.lua'

client_script 'Z-Logs/client/client.lua'

file 'Z-Logs/postals.json'
postal_file 'Z-Logs/postals.json'
file 'Z-Logs/version.json'

----------------------------------Welcome----------------------

client_script 'Z-Welcome/client.lua'

------------------------------ Data Files n shi ----------------------------------

files {
  "data/**/*.meta",
}


files {
	"weapons.meta",
}

files {
    "popcycle.dat"
}

data_file "POPSCHED_FILE" "popcycle.dat"
data_file "WEAPONINFO_FILE_PATCH" "weapons.meta"
data_file "HANDLING_FILE"            "data/**/handling.meta"
data_file "CARCOLS_FILE"            "data/**/carcols.meta"
data_file "VEHICLE_METADATA_FILE" "data/**/vehicles.meta"
data_file "VEHICLE_VARIATION_FILE"    "data/**/carvariations*.meta"

files {   


        'weapons.meta',
    
        'Z-Mata/mosin/weaponanimations.meta',
        'Z-Mata/mosin/weaponarchetypes.meta',
        'Z-Mata/mosin/weapons.meta',
        'Z-Mata/mosin/weaponcomponents.meta',
    
        'Z-Mata/vehicles/divo/vehicles.meta',
        'Z-Mata/vehicles/divo/carvariations.meta',
        'Z-Mata/vehicles/divo/carcols.meta',
        'Z-Mata/vehicles/divo/handling.meta',
        'Z-Mata/vehicles/divo/vehiclelayouts.meta',
   
    }
    
    data_file "WEAPONINFO_FILE_PATCH" "weapons.meta"
    
    data_file 'WEAPONINFO_FILE' 'Z-Mata/mosin/weapons.meta'
    data_file 'WEAPON_METADATA_FILE' 'Z-Mata/mosin/weaponarchetypes.meta'
    data_file 'WEAPON_ANIMATIONS_FILE' 'Z-Mata/mosin/weaponanimations.meta'
    data_file 'WEAPONCOMPONENTSINFO_FILE' 'Z-Mata/mosin/weaponcomponents.meta'
    
    data_file 'HANDLING_FILE' 'Z-Mata/vehicles/divo/handling.meta'
    data_file 'VEHICLE_METADATA_FILE' 'Z-Mata/vehicles/divo/vehicles.meta'
    data_file 'CARCOLS_FILE' 'Z-Mata/vehicles/divo/carcols.meta'
    data_file 'VEHICLE_VARIATION_FILE' 'Z-Mata/vehicles/divo/carvariations.meta'
    data_file 'VEHICLE_LAYOUTS_FILE' 'Z-Mata/vehicles/divo/vehiclelayouts.meta'
    

    