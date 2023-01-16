Config = {}

Config.AllLogs = false											-- Enable/Disable All Logs Channel
Config.postal = false 											-- set to false if you want to disable nerest postal (https://forum.cfx.re/t/release-postal-code-map-minimap-new-improved-v1-2/147458)
Config.username = "Time RZ" 							-- Bot Username
Config.avatar = ""				-- Bot Avatar
Config.communtiyName = "Time RZ"					-- Icon top of the Embed
Config.communtiyLogo = ""		-- Icon top of the Embed


Config.weaponLog = false 			-- set to false to disable the shooting weapon logs
Config.weaponLogDelay = 1000		-- delay to wait after someone fired a weapon to check again in ms (put to 0 to disable) Best to keep this at atleast 1000

Config.playerID = true				-- set to false to disable Player ID in the logs
Config.steamID = true				-- set to false to disable Steam ID in the logs
Config.steamURL = true				-- set to false to disable Steam URL in the logs
Config.discordID = true				-- set to false to disable Discord ID in the logs


-- Change color of the default embeds here
-- It used Decimal color codes witch you can get and convert here: https://jokedevil.com/colorPicker
Config.joinColor = "3863105" 		-- Player Connecting
Config.leaveColor = "15874618"		-- Player Disconnected
Config.chatColor = "10592673"		-- Chat Message
Config.shootingColor = "10373"		-- Shooting a weapon
Config.deathColor = "000000"		-- Player Died
Config.resourceColor = "15461951"	-- Resource Stopped/Started



Config.webhooks = {
	all = "", -- If you server dumped just to spam you're a verified faggot <3
	chat = "https://discord.com/api/webhooks/922623188263911475/2pxEOTFg8eT4Hb5e8bvI1nbtMEmvBWcEi8cFdLo8k9IA__-5lsBmZR9sE-lvRgDrSWgN",
	joins = "https://discord.com/api/webhooks/922623034832093225/1Yc7KoCkfdGTNuA5_JJDN1sQNLRS-I9xuh8__5LsutxBhftaLCktNPPFV0clmopiXlWQ",
	leaving = "https://discord.com/api/webhooks/922623063974096946/lDRmbJ6HJVfZvHQ3PumkweHW0pPIfNFsPQqqrstSOMBTc1LEJYUGAcHbLO7O7ZP6OxEu",
	deaths = "",
	shooting = "",
	resources = "",

  -- How you add more logs is explained on https://docs.jokedevil.com/JD_logs
  }


 --Debug shizzels :D
Config.debug = false
Config.versionCheck = "1.1.0"
