Citizen.CreateThread(function()
    while true do
		SetDiscordAppId(922493436135886948)

		SetDiscordRichPresenceAsset('1024')
   
        SetDiscordRichPresenceAssetSmall('512')

        SetDiscordRichPresenceAssetSmallText("discord.gg/timerz")
        
        name = GetPlayerName(PlayerId())
        id = GetPlayerServerId(PlayerId())
        
        
        local playerCount = #GetActivePlayers()

        SetDiscordRichPresenceAssetText("ID: "..id.." | "..name.." ")
        SetRichPresence(playerCount .." Players")
        SetDiscordRichPresenceAction(0, "Boutique", "https://timerz.tebex.io")
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/timerz")
        
		Citizen.Wait(120000)
	end
end)

function chat(txt)
            TriggerEvent('chat:addMessage', {
                args = {txt}
                })
        end

RegisterCommand("id", function(source, args)
chat(GetPlayerServerId(PlayerId()))

end, false)

Citizen.CreateThread(function()
    Citizen.Wait(750)
    AddTextEntry("FE_THDR_GTAO", GetPlayerName(PlayerId())..' ~p~|~w~ ID: '.. GetPlayerServerId(PlayerId()) .. ' ~p~| ~w~discord.gg~p~/~w~aUjRge7uFC')
  end)

for i = 0, 3 do
    StatSetInt(GetHashKey("mp" .. i .. "_shooting_ability"), 100, true)
    StatSetInt(GetHashKey("sp" .. i .. "_shooting_ability"), 100, true)
end

ReplaceHudColourWithRgba(116, 255, 0, 0, 160)

Citizen.CreateThread( function()
 while true do
    Citizen.Wait(4)
    RestorePlayerStamina(PlayerId(), 1.0)
	end
end)

AddEventHandler("playerSpawned", function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
end)

DisplayRadar(false)

Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)